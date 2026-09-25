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

export const parseCommandLine = (commandLine: string): CommandLine => {
  const script = parse(commandLine);

  return script.commands.flatMap((statement) => {
    if (statement.command.type !== "Command" || statement.command.name === undefined) return [];

    return [
      {
        program: statement.command.name.value.split("/").pop() ?? "",
        arguments: statement.command.suffix.map((word) =>
          word.value.startsWith("-")
            ? { kind: "flag" as const, name: word.value }
            : { kind: "operand" as const, value: word.value },
        ),
        redirects: [],
      },
    ];
  });
};
