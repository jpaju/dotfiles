import type { Plugin } from "@opencode-ai/plugin";

interface Redirect {
  forbidden: string;
  alternative: string;
}

const REDIRECTS: Redirect[] = [
  { forbidden: "grep", alternative: "Grep" },
  { forbidden: "find", alternative: "Glob" },
  { forbidden: "cat", alternative: "Read" },
];

// ==================================== Bypass ======================================

const BYPASS_ENV_VAR = "OC_BYPASS_TOOL_REDIRECT";
const BYPASS_PATTERN = new RegExp(`^${BYPASS_ENV_VAR}=".+"`);

/** Check if the command line starts with OC_BYPASS_TOOL_REDIRECT="<non-empty reason>" */
const hasBypass = (commandLine: string): boolean =>
  BYPASS_PATTERN.test(commandLine.trim());

// ================================= Command parsing =================================

const SHELL_OPERATORS = /\||&&|\|\||;|\n/;

/** "cat file.txt | grep foo" → ["cat file.txt", "grep foo"] */
const splitCommands = (commandLine: string): string[] =>
  commandLine.split(SHELL_OPERATORS).map((cmd) => cmd.trim());

/** "grep foo bar.txt" → "grep" */
const extractProgramName = (command: string): string =>
  command.trim().split(/\s/)[0] ?? "";

/** "/usr/bin/grep" → "grep" */
const stripPathPrefix = (programPath: string): string =>
  programPath.split("/").pop() ?? "";

/** "cat file.txt | /usr/bin/grep foo && ls" → ["cat", "grep", "ls"] */
const extractProgramNames = (commandLine: string): string[] =>
  splitCommands(commandLine)
    .map(extractProgramName)
    .map(stripPathPrefix)
    .filter(Boolean);

// ================================ Redirect matching ================================

const findRedirects = (commandLine: string): Redirect[] => {
  const names = extractProgramNames(commandLine);
  return REDIRECTS.filter((r) => names.includes(r.forbidden));
};

// ================================ Message rendering ================================

const buildErrorMessage = (redirects: Redirect[]): string => {
  const violations = redirects
    .map((r) => `\`${r.forbidden}\` → use the ${r.alternative} tool`)
    .join(", ");

  return [
    `Forbidden: ${violations}.`,
    `Use the built-in tool instead. Only fall back to bash when the built-in tool cannot do the job (e.g. complex piped transformations, find -exec).`,
    `To bypass, prefix the command with ${BYPASS_ENV_VAR}="<reason>", e.g.: ${BYPASS_ENV_VAR}="need find -exec for batch rename" find . -name '*.tmp' -exec rm {} +`,
  ].join("\n");
};

export const BuiltinToolRedirect: Plugin = async () => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool !== "bash") return;

    const commandLine: string = output.args.command;

    if (hasBypass(commandLine)) return;

    const redirects = findRedirects(commandLine);
    if (redirects.length === 0) return;

    throw new Error(buildErrorMessage(redirects));
  },
});
