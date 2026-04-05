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

  return `Forbidden: ${violations}. Only fall back to bash when built-in tools lack the capability.`;
};

export const BuiltinToolRedirect: Plugin = async () => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool !== "bash") return;

    const redirects = findRedirects(output.args.command);
    if (redirects.length === 0) return;

    const message = buildErrorMessage(redirects);
    throw new Error(message);
  },
});
