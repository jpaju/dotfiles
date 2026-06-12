# Technical design: detecting unsafe arguments and file redirection

## Approach

The current plugin classifies commands with regular expressions: it splits the command line on shell operators, strips path prefixes, and matches program names and substrings. This cannot reliably answer the two questions the feature needs:

- Does a command carry a specific argument (e.g. `find -exec`), accounting for argument position, quoting, and `--` end-of-options?
- Does the command line write to a real file through redirection, while ignoring stream redirections and `/dev/null`?

Both require parsing the command line into a structured form. We parse it with [`unbash`](https://www.npmjs.com/package/unbash), a pure-TypeScript, zero-dependency, synchronous bash parser whose AST exposes, per command, the program name, its argument words, and its redirections, and which represents nesting (pipelines, subshells, command substitutions).

The plugin never sees `unbash`'s types. We translate its AST into a dedicated domain model that exposes only what this feature needs. This keeps the parser replaceable and keeps the plugin's logic readable in domain terms; the parser-specific details stay in one place. The rest of this document defines that domain model and the API around it.

## Domain model

The command line is flattened into the set of concrete commands it will run, including those nested inside pipelines, lists, subshells, and command/process substitutions, because the feature inspects nested commands too.

Each command is exposed as:

```ts
interface ParsedCommand {
  program: string; // basename, path-stripped: "/usr/bin/find" -> "find"
  args: string[]; // argument words, in order
  // redirect exposure: see open design decision below
}
```

`program` is the path-stripped basename so that `/usr/bin/find` and `find` are treated identically (the current plugin already does this).

The plugin receives the flattened list of `ParsedCommand`s and applies its rules to each.

### Open design decision: how to expose redirections

The product requirements only ask one thing about redirection: does the command write to a real file? Everything in the allowed set (`> /dev/null`, stream redirections like `2>&1`) is safe; everything else that uses an output operator targeting a filename is unsafe.

Two candidate shapes for the domain model:

**Option A: collapse to a boolean.** The model classifies redirections and exposes a single flag per command:

```ts
interface ParsedCommand {
  program: string;
  args: string[];
  writesToFile: boolean;
}
```

The plugin never sees redirect operators or targets. Simplest, and it matches exactly what the requirements ask. The cost is that the "what counts as writing to a file" policy lives in the translation layer rather than alongside the other rules in the plugin.

**Option B: expose a typed redirect list.** The model surfaces a domain redirect type and lets the plugin decide:

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

More flexible (the allow/deny policy for redirect targets lives with the other plugin rules), but it widens the model's surface and pushes shell-redirection nuance toward the plugin.

This is the main thing to iterate on. Leaning toward Option A for simplicity unless we expect the redirect policy to grow.

## Parsing API

A single entry point turns a command line into the domain model:

```ts
function parseCommandLine(commandLine: string): ParsedCommand[];
```

This is the only place that touches `unbash`. It flattens the AST and performs the translation (path-stripping, redirect classification) so that callers receive nothing but the domain model.

The behaviour when the command line cannot be parsed or understood is an open question (see the requirements: fail open vs. fail closed, and how the user learns the plugin has stopped working). `unbash` is tolerant and collects parse errors rather than throwing, so the API must define what it returns in that case.

## Rules API

The dangerous-argument configuration (the table from the requirements) lives in the plugin as data. The parsing layer stays generic: it does not know that `find -exec` is dangerous.

A rule is expressed against the domain model:

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
3. Parse the command line into `ParsedCommand`s.
4. Evaluate rules; if any command matches a rule, throw with a message naming the violation and how to bypass.

The regex helpers that drive matching today are replaced by `parseCommandLine` and the domain matchers. The bypass detection and message rendering are reused.

## Testing

The parsing and rules are pure functions over strings, so they are straightforward to unit test without OpenCode. Cover at least:

- Each dangerous argument from the requirements table (positive and negative, including `--` end-of-options and path-prefixed programs).
- Redirections: `> file` blocked; `>> file`, `&> file`, `>| file` blocked; `> /dev/null` and `2>&1` allowed.
- Nesting: a dangerous command inside a pipeline, subshell, and command substitution is still detected.
- Bypass prefix short-circuits evaluation.
