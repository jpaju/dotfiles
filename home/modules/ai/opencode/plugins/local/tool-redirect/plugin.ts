import type { Plugin } from "@opencode-ai/plugin";

interface Redirect {
  forbidden: string;
  alternative: string;
}

const REDIRECTS: Redirect[] = [
  { forbidden: "find", alternative: "Glob tool" },
  { forbidden: "curl", alternative: "WebFetch tool" },
  { forbidden: "git -C", alternative: "workdir parameter on Bash tool" },
  {
    forbidden: "cd",
    alternative:
      "workdir parameter on Bash tool or path parameter on Glob/Grep tools",
  },
];

// ==================================== Bypass ======================================

const BYPASS_ENV_VAR = "OC_BYPASS_TOOL_REDIRECT";
const BYPASS_PATTERN = new RegExp(`^${BYPASS_ENV_VAR}=".+"`);

/** Check if the command line starts with OC_BYPASS_TOOL_REDIRECT="<non-empty reason>" */
const hasBypass = (commandLine: string): boolean =>
  BYPASS_PATTERN.test(commandLine.trim());

// ================================= Command parsing =================================

const SHELL_OPERATORS = /\||&&|\|\||;|\n/;

/** "cat file.txt | grep foo && ls" → ["cat file.txt", "grep foo", "ls"] */
const splitCommands = (commandLine: string): string[] =>
  commandLine.split(SHELL_OPERATORS).map((cmd) => cmd.trim());

/** "grep foo bar.txt" → "grep" */
const extractProgramName = (command: string): string =>
  command.trim().split(/\s/)[0] ?? "";

/** "/usr/bin/grep foo" → "grep foo" */
const stripPathPrefix = (command: string): string => {
  const program = extractProgramName(command);
  const basename = program.split("/").pop() ?? "";
  return basename + command.slice(program.length);
};

// ================================ Redirect matching ================================

/** Check if a command segment starts with a forbidden prefix */
const matchesRedirect = (command: string, redirect: Redirect): boolean =>
  command.startsWith(redirect.forbidden);

const findRedirects = (commandLine: string): Redirect[] => {
  const commands = splitCommands(commandLine).map(stripPathPrefix);
  return REDIRECTS.filter((r) =>
    commands.some((cmd) => matchesRedirect(cmd, r)),
  );
};

// ================================ Message rendering ================================

const buildErrorMessage = (redirects: Redirect[]): string => {
  const violations = redirects
    .map((r) => `\`${r.forbidden}\` → use the ${r.alternative}`)
    .join(", ");

  return [
    `Forbidden: ${violations}.`,
    `If the built-in tool cannot do the job (e.g. find -exec, complex piped transformations), prefix the command with ${BYPASS_ENV_VAR}="<reason>" to bypass.`,
  ].join("\n");
};

export const ToolRedirect: Plugin = async () => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool !== "bash") return;
    if (hasBypass(output.args.command)) return;

    const redirects = findRedirects(output.args.command);

    if (redirects.length === 0) return;
    else throw new Error(buildErrorMessage(redirects));
  },
});
