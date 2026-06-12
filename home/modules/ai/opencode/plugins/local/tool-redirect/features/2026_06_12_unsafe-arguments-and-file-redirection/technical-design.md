# Technical design: detecting unsafe arguments and file redirection

## Approach

The current plugin classifies commands with regular expressions: it splits the command line on shell operators, strips path prefixes, and matches program names and substrings. This cannot reliably answer the two questions the feature needs:

- Does a command carry a specific argument (e.g. `find -exec`), accounting for argument position, quoting, and `--` end-of-options?
- Does the command line write to a real file through redirection, while ignoring stream redirections and `/dev/null`?

Both require parsing the command line into a structured form. We parse it with [`unbash`](https://www.npmjs.com/package/unbash), a pure-TypeScript, zero-dependency, synchronous bash parser whose AST exposes, per command, the program name, its argument words, and its redirections, and which represents nesting (pipelines, subshells, command substitutions).

The plugin never sees `unbash`'s types. We translate its AST into a dedicated domain model that exposes only what this feature needs. This keeps the parser replaceable and keeps the plugin's logic readable in domain terms; the parser-specific details stay in one place. The rest of this document defines that domain model and the API around it.

## Domain model

The model is a small AST. A command line is flattened into the set of concrete commands it will run, including those nested inside pipelines, lists, subshells, and command/process substitutions, because the feature inspects nested commands too.

```ts
type CommandLine = Command[];
```

A command keeps its parts structured rather than as flat strings, so rules can ask precise questions (is this a flag, what is it named, what does this redirect target).

```ts
interface Command {
  program: string; // basename, path-stripped: "/usr/bin/find" -> "find"
  arguments: Argument[];
  redirects: Redirect[];
}
```

`program` is the path-stripped basename so that `/usr/bin/find` and `find` are treated identically.

### Arguments

An argument is either a flag or an operand. Modelling the distinction lets a rule match `find -delete` (a flag) separately from `sort out.txt` (an operand written to), without re-parsing strings.

```ts
type Argument =
  | { kind: "flag"; name: string } // "-exec", "--in-place"
  | { kind: "operand"; value: string }; // "src/", "out.txt"
```

### Redirects

A redirect is an algebraic type over its operator and its target. The operator says whether it reads or writes; the target says where the data goes. Together they answer the only question the feature asks: does this write to a real file.

```ts
type Redirect = {
  operator: RedirectOperator;
  target: RedirectTarget;
};

type RedirectOperator =
  | "read" // <
  | "write" // >, >|
  | "append" // >>
  | "writeAll" // &>, >&
  | "appendAll" // &>>
  | "duplicate"; // 2>&1 and friends

type RedirectTarget =
  | { kind: "file"; path: string } // a real file on disk
  | { kind: "devNull" } // /dev/null
  | { kind: "descriptor"; fd: number }; // an existing stream, e.g. 2>&1
```

This is richer than the feature strictly needs today (it only has to flag a write whose target is a `file`), but the structure keeps the model honest about what a redirect is and leaves room for the deferred cases (other `/dev/*` targets, process substitution) without reshaping it.

This is the main thing to iterate on: the exact set of operators and target variants, and whether this is more structure than we want.

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
