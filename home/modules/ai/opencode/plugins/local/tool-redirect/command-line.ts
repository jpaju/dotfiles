import { parse } from "unbash";

export type CommandLine = Command[];

export interface Command {
  program: string;
  arguments: Argument[];
  redirects: Redirect[];
}

export type RedirectOperator = ">" | ">>" | ">|" | "&>" | "&>>" | ">&" | "<>";

export type Stdio = "stdin" | "stdout" | "stderr";

export type Argument = { kind: "flag"; name: string } | { kind: "operand"; value: string };

export type RedirectTarget = { kind: "file"; path: string } | { kind: "stdio"; stdio: Stdio };

export interface Redirect {
  operator: RedirectOperator;
  target: RedirectTarget;
}

const parseArgument = (value: string): Argument => {
  if (!value.startsWith("-")) return { kind: "operand", value };

  const equalsIndex = value.startsWith("--") ? value.indexOf("=") : -1;
  return { kind: "flag", name: equalsIndex === -1 ? value : value.slice(0, equalsIndex) };
};

export const parseCommandLine = (commandLine: string): CommandLine => {
  const script = parse(commandLine);

  return script.commands.flatMap((statement) => {
    if (statement.command.type !== "Command" || statement.command.name === undefined) return [];

    return [
      {
        program: statement.command.name.value.split("/").pop() ?? "",
        arguments: statement.command.suffix.map((word) => parseArgument(word.value)),
        redirects: [],
      },
    ];
  });
};
