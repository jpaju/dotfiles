# Technical design: detecting unsafe arguments and file redirection

This document describes how to implement the feature specified in [`product-requirements.md`](./product-requirements.md).

## Approach

The current plugin classifies commands with regular expressions: it splits the command line on shell operators, strips path prefixes, and matches program names and substrings. This cannot reliably answer the two questions the feature needs:

- Does a command carry a specific argument (e.g. `find -exec`), accounting for argument position, quoting, and `--` end-of-options?
- Does the command line write to a real file through redirection, while ignoring stream redirections and `/dev/null`?

Both require parsing the command line into a structured form. We parse it with a real shell parser and inspect the resulting syntax tree.

## Anti-corruption layer

The plugin does not depend on the parsing library directly. An anti-corruption layer (ACL) sits between the library and the plugin: it consumes the library's syntax tree and produces a small domain model expressed in the terms the feature cares about. The plugin reasons only against that domain model.

This keeps the library replaceable, keeps the plugin's logic readable in domain terms, and isolates the messy details of shell grammar in one place.

```
command line ──▶ parser library ──▶ ACL ──▶ domain model ──▶ plugin rules ──▶ allow / block
                 (unbash)            (translate + flatten)    (policy)
```

### Parsing library

We use [`unbash`](https://www.npmjs.com/package/unbash): a pure-TypeScript, zero-dependency, synchronous bash parser. It produces a typed AST that exposes, per command, the program name, its argument words, and its redirections (with typed operators and targets), and it represents nesting (pipelines, subshells, command substitutions). It is small, well maintained, and needs no WASM initialisation, which matters because parsing happens synchronously inside the `tool.execute.before` hook on every bash command.

The library is named here only because the ACL is the sole module that imports it. No other part of the plugin references it.

## Domain model

The ACL flattens the AST into the set of concrete commands the command line will run, including those nested inside pipelines, lists, subshells, and command/process substitutions, because the feature inspects nested commands too.

Each command is exposed as something like:

```ts
interface ParsedCommand {
  program: string; // basename, path-stripped: "/usr/bin/find" -> "find"
  args: string[]; // argument words, in order
  // redirect exposure: see open design decision below
}
```

`program` is the path-stripped basename so that `/usr/bin/find` and `find` are treated identically (the current plugin already does this with `stripPathPrefix`).

The plugin receives the flattened list of `ParsedCommand`s and applies its rules to each.

### Open design decision: how to expose redirections

The product requirements only ask one thing about redirection: does the command write to a real file? Everything in the allowed set (`> /dev/null`, stream redirections like `2>&1`) is safe; everything else that uses an output operator targeting a filename is unsafe.

Two candidate shapes for the ACL boundary:

**Option A: collapse to a boolean.** The ACL classifies redirections itself and exposes a single flag per command:

```ts
interface ParsedCommand {
  program: string;
  args: string[];
  writesToFile: boolean;
}
```

The plugin never sees redirect operators or targets. Simplest, and it matches exactly what the requirements ask. The cost is that the "what counts as writing to a file" policy lives inside the ACL rather than alongside the other rules in the plugin.

**Option B: expose a typed redirect list.** The ACL surfaces a domain redirect type and lets the plugin decide:

```ts
interface ParsedRedirect {
  writesOutput: boolean; // uses an output operator
  target: RedirectTarget; // "file" | "devNull" | "stream" | ...
}

interface ParsedCommand {
  program: string;
  args: string[];
  redirects: ParsedRedirect[];
}
```

More flexible (the allow/deny policy for redirect targets lives with the other plugin rules), but it widens the ACL surface and pushes shell-redirection nuance toward the plugin.

This is the main thing to iterate on. Leaning toward Option A for simplicity unless we expect the redirect policy to grow.

## Plugin rules

The dangerous-argument configuration (the table from the requirements) lives in the plugin as data, not in the ACL. The ACL stays generic: it parses and translates, it does not know that `find -exec` is dangerous.

A rule is expressed against the domain model, for example:

```ts
interface Rule {
  label: string; // human-readable, for the block message
  matches: (command: ParsedCommand) => boolean;
}
```

with small matcher builders in domain terms:

- `programWithArg(program, arg)` — e.g. `find` carrying `-exec` / `-execdir` / `-delete`, `sed` carrying `-i` / `--in-place`, `sort` carrying `-o` / `--output`.
- `programWithExtraFileOperand(program)` — the positional-write cases (`sort`, `uniq`).
- a redirection rule derived from the chosen redirect exposure (Option A: `command.writesToFile`).

The plugin evaluates every parsed command against every rule; any match blocks the command line.

## Integration with the existing plugin

The `tool.execute.before` hook keeps its shape:

1. Ignore non-`bash` tools.
2. Honour the existing bypass mechanism (`OC_BYPASS_*="<reason>"` prefix).
3. Parse the command line via the ACL into `ParsedCommand`s.
4. Evaluate rules; if any command matches a rule, throw with a message naming the violation and how to bypass.

The regex helpers that drive matching today (`splitCommands`, `extractProgramName`, `stripPathPrefix`, `programIs`, `startsWith`, `containsFlag`) are replaced by the ACL and the domain matchers. The bypass detection and message rendering are reused.

## Module layout

```
plugin.ts          plugin entry, hook, rule table, bypass + message rendering
shell/parse.ts     the ACL: unbash -> ParsedCommand[]  (only file importing unbash)
shell/model.ts     domain types (ParsedCommand, Rule, ...)
```

(Exact split to be confirmed; the key constraint is that only the ACL module imports `unbash`.)

## Dependency wiring

`unbash` must be available to the plugin at runtime. OpenCode installs dependencies for local plugins from a `package.json` in the config root (`~/.config/opencode/`), running `bun install` at startup. That file currently lists only `@opencode-ai/plugin` and is generated/managed by OpenCode rather than by nix.

Open item: confirm how to add `unbash` declaratively (nix-managing the config-root `package.json`) without OpenCode overwriting it, and fall back to bundling `unbash` into the plugin at nix build time if that proves unreliable. To be resolved before implementation.

## Behaviour on parse failure

`unbash` is tolerant and collects parse errors rather than throwing. The requirements leave the parse-failure default open (fail open vs. fail closed, and how the user learns the plugin has stopped working). The implementation must pick a defined behaviour for the case where the command cannot be parsed or understood; this is tracked as an open question in the requirements.

## Testing

The ACL and rules are pure functions over strings, so they are straightforward to unit test without OpenCode. Cover at least:

- Each dangerous argument from the requirements table (positive and negative, including `--` end-of-options and path-prefixed programs).
- Redirections: `> file` blocked; `>> file`, `&> file`, `>| file` blocked; `> /dev/null` and `2>&1` allowed.
- Nesting: a dangerous command inside a pipeline, subshell, and command substitution is still detected.
- Bypass prefix short-circuits evaluation.
