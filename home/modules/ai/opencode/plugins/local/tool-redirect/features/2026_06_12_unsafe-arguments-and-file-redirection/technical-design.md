# Technical design: detecting unsafe arguments and file redirection

## Approach

The current plugin classifies commands with regular expressions: it splits the command line on shell operators, strips path prefixes, and matches program names and substrings. This cannot reliably answer the two questions the feature needs:

- Does a command carry a specific argument (e.g. `find -exec`), accounting for argument position, quoting, and `--` end-of-options?
- Does the command line write to a real file through redirection, while ignoring stream redirections and `/dev/null`?

Both require parsing the command line into a structured form. We parse it with [`unbash`](https://www.npmjs.com/package/unbash), a pure-TypeScript, zero-dependency, synchronous bash parser whose AST exposes, per command, the program name, its argument words, and its redirections, and which represents nesting (pipelines, subshells, command substitutions).

The plugin never sees `unbash`'s types. We translate its AST into a dedicated domain model that exposes only what this feature needs. This keeps the parser replaceable and keeps the plugin's logic readable in domain terms; the parser-specific details stay in one place. The rest of this document defines that domain model and the API around it.

## Domain model

The model is a small AST. A command line is flattened into the set of concrete commands it will run, including those nested inside pipelines, lists, and subshells, because the feature inspects nested commands too.

```ts
type CommandLine = Command[];
```

A command keeps its parts structured rather than as flat strings, so rules can ask precise questions (is this a flag, what is it named, what does this redirect target).

```ts
interface Command {
  program: string;
  arguments: Argument[];
  redirects: Redirect[];
}
```

`program` is reduced to its basename so that `/usr/bin/find`, `./find`, and `find` are all treated identically; rules key on the program name, not on how it was located.

### Arguments

An argument is either a flag or an operand.

```ts
type Argument =
  | { kind: "flag"; name: string } // "-exec", "--in-place"
  | { kind: "operand"; value: string }; // "src/", "out.txt"
```

Each word is classified on its own. A flag that takes a separate value (`--output file.txt`) is kept as two arguments: a `flag` (`--output`) followed by an `operand` (`file.txt`). Whether the operand belongs to the flag depends on per-program knowledge the parser does not have, so a rule that cares about the pairing inspects the adjacency itself rather than relying on the parser to attach it.

### Redirects

A redirect has the literal shell operator and a target. Only output operators are modelled; input redirections (`<`, `<&`) never write a file, so the feature ignores them.

```ts
type RedirectOperator = ">" | ">>" | ">|" | "&>" | "&>>" | ">&";

type Stdio = "stdin" | "stdout" | "stderr";

type RedirectTarget = { kind: "file"; path: string } | { kind: "stdio"; stdio: Stdio };

type Redirect = {
  operator: RedirectOperator;
  target: RedirectTarget;
};
```

A `stdio` target points at one of the three standard streams (`stdin`, `stdout`, `stderr`), as produced by `2>&1` (stderr to stdout); it never writes to disk. We model it as this closed set rather than a raw file-descriptor number: the descriptors that appear in the commands this plugin inspects are the standard `0`/`1`/`2`, a number would also admit meaningless values (negative, or arbitrarily high), and naming the streams is clearer than their numeric ids. Higher descriptors opened explicitly via `exec` are out of scope.

Only the redirect's target matters for the feature (does it write a real file). The source side of a redirect (e.g. the `2` in `2> errs.txt`) is intentionally not modelled.

### Worked examples

`/usr/bin/git status --short`

```ts
[
  {
    program: "git",
    arguments: [
      { kind: "operand", value: "status" },
      { kind: "flag", name: "--short" },
    ],
    redirects: [],
  },
];
```

`cargo test 2>&1 | head` (a pipeline, so two commands)

```ts
[
  {
    program: "cargo",
    arguments: [{ kind: "operand", value: "test" }],
    redirects: [{ operator: ">&", target: { kind: "stdio", stdio: "stdout" } }],
  },
  {
    program: "head",
    arguments: [],
    redirects: [],
  },
];
```

`gh repo --help > gh-help.txt`

```ts
[
  {
    program: "gh",
    arguments: [
      { kind: "operand", value: "repo" },
      { kind: "flag", name: "--help" },
    ],
    redirects: [{ operator: ">", target: { kind: "file", path: "gh-help.txt" } }],
  },
];
```

`cargo build 2> errs.txt`

```ts
[
  {
    program: "cargo",
    arguments: [{ kind: "operand", value: "build" }],
    redirects: [{ operator: ">", target: { kind: "file", path: "errs.txt" } }],
  },
];
```

`npm test 2> /dev/null`

```ts
[
  {
    program: "npm",
    arguments: [{ kind: "operand", value: "test" }],
    redirects: [{ operator: ">", target: { kind: "file", path: "/dev/null" } }],
  },
];
```

`cd $(git rev-parse --show-toplevel)` (command substitution: outer + inner, both flattened)

```ts
[
  {
    program: "cd",
    arguments: [{ kind: "operand", value: "$(git rev-parse --show-toplevel)" }],
    redirects: [],
  },
  {
    program: "git",
    arguments: [
      { kind: "operand", value: "rev-parse" },
      { kind: "flag", name: "--show-toplevel" },
    ],
    redirects: [],
  },
];
```

The outer `cd` keeps the substitution as an opaque operand; the inner `git rev-parse` is flattened alongside it so rules inspect it directly.

## Parsing API

A single entry point turns a command line into the domain model:

```ts
function parseCommandLine(commandLine: string): CommandLine;
```

This is the only place that touches `unbash`. It flattens the AST and performs the translation (path-stripping, argument and redirect classification) so that callers receive nothing but the domain model.

The behaviour when the command line cannot be parsed or understood is an open question (see the requirements: fail open vs. fail closed, and how the user learns the plugin has stopped working). `unbash` is tolerant and collects parse errors rather than throwing, so the API must define what it returns in that case.

## Rules API

The dangerous-argument configuration (the table from the requirements) lives in the plugin as data. The parsing layer stays generic: it does not know that `find -exec` is dangerous.

A rule is expressed against the domain model:

```ts
interface Rule {
  label: string; // human-readable, for the block message
  matches: (command: Command) => boolean;
}
```

with small matcher builders in domain terms:

- `programWithFlag(program, flag)` — e.g. `find` carrying `-exec` / `-execdir` / `-delete`, `sed` carrying `-i` / `--in-place`, `sort` carrying `-o` / `--output`.
- `programWithExtraFileOperand(program)` — the positional-write cases (`sort`, `uniq`).
- `writesToFile` — any redirect whose operator writes and whose target is a `file`.

The plugin evaluates every command against every rule; any match blocks the command line.

## Integration with the existing plugin

The `tool.execute.before` hook keeps its shape:

1. Ignore non-`bash` tools.
2. Honour the existing bypass mechanism (`OC_BYPASS_*="<reason>"` prefix).
3. Parse the command line into a `CommandLine`.
4. Evaluate rules; if any command matches a rule, throw with a message naming the violation and how to bypass.

The regex helpers that drive matching today are replaced by `parseCommandLine` and the domain matchers. The bypass detection and message rendering are reused.
