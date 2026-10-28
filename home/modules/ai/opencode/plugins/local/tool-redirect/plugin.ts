import { Plugin } from "@opencode/plugin/effect";
import * as Tool from "@opencode/plugin/promise/tool";
import { Effect, Schema } from "effect";

// ================================= Command parsing =================================

const SHELL_OPERATORS = /\||&&|\|\||;|\n/;

/** "cat file.txt | grep foo && ls" → ["cat file.txt", "grep foo", "ls"] */
const splitCommands = (commandLine: string): string[] =>
  commandLine.split(SHELL_OPERATORS).map((cmd) => cmd.trim());

/** "grep foo bar.txt" → "grep" */
const extractProgramName = (command: string): string => command.trim().split(/\s/)[0] ?? "";

/** "/usr/bin/grep foo" → "grep foo" */
const stripPathPrefix = (command: string): string => {
  const program = extractProgramName(command);
  const basename = program.split("/").pop() ?? "";
  return basename + command.slice(program.length);
};

// ==================================== Bypass ======================================

const BYPASS_ENV_VAR = "OC_BYPASS_TOOL_REDIRECT";
const BYPASS_PATTERN = new RegExp(`^${BYPASS_ENV_VAR}=".+"`);

/** Check if the command line starts with OC_BYPASS_TOOL_REDIRECT="<non-empty reason>" */
const hasBypass = (commandLine: string): boolean => BYPASS_PATTERN.test(commandLine.trim());

// ============================= Redirects & matching ================================

interface Redirect {
  label: string;
  matches: Matcher;
  alternative: string;
}

type Matcher = (command: string) => boolean;

const programIs =
  (programName: string): Matcher =>
  (command) =>
    extractProgramName(command) === programName;

const startsWith =
  (prefix: string): Matcher =>
  (command) =>
    command.startsWith(prefix);

const containsFlag =
  (flag: string): Matcher =>
  (command) =>
    command.includes(flag);

const findRedirects = (commandLine: string): Redirect[] => {
  const commands = splitCommands(commandLine).map(stripPathPrefix);
  return REDIRECTS.filter((redirect) => commands.some((cmd) => redirect.matches(cmd)));
};

// ================================ Message rendering ================================

const buildErrorMessage = (redirects: Redirect[]): string => {
  const violations = redirects.map((r) => `\`${r.label}\` → use the ${r.alternative}`).join(", ");

  return [
    `Blocked: ${violations}.`,
    `If the built-in tool cannot do the job (e.g. find -exec, complex piped transformations), prefix the command with ${BYPASS_ENV_VAR}="<reason>" to bypass.`,
  ].join("\n");
};

// ================================= Plugin & config ===================================

const REDIRECTS: Redirect[] = [
  {
    label: "find",
    matches: programIs("find"),
    alternative: "Glob tool",
  },
  {
    label: "curl",
    matches: programIs("curl"),
    alternative: "WebFetch tool",
  },
  {
    label: "git -C <path> <cmd>",
    matches: startsWith("git -C"),
    alternative: "Shell tool with workdir parameter (`git <cmd>`)",
  },
  {
    label: "cd",
    matches: programIs("cd"),
    alternative: "workdir/path parameters on Shell, Glob, or Grep tools",
  },
];

const ShellInput = Schema.Struct({ command: Schema.String });

export default Plugin.define({
  id: "tool-redirect",
  effect: (ctx) =>
    Effect.gen(function* () {
      yield* ctx.tool.hook("execute.before", (event) =>
        Effect.gen(function* () {
          if (event.tool !== "shell") return;

          const { command } = yield* Schema.decodeUnknownEffect(ShellInput)(event.input).pipe(
            Effect.mapError(() => new Tool.Error({ message: "Shell tool input must contain a string command" })),
          );
          if (hasBypass(command)) return;

          const redirects = findRedirects(command);

          if (redirects.length === 0) return;
          yield* Effect.fail(new Tool.Error({ message: buildErrorMessage(redirects) }));
        }),
      );
    }),
});
