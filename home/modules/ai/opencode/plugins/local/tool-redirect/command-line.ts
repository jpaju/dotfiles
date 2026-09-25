import {
  parse,
  type Node,
  type ParsedScript,
  type Redirect as BashRedirect,
  type Word,
} from "unbash";

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

const parseArguments = (values: string[]): Argument[] => {
  const arguments_: Argument[] = [];
  let acceptsFlags = true;

  for (const value of values) {
    if (acceptsFlags && value === "--") {
      acceptsFlags = false;
      continue;
    }

    arguments_.push(acceptsFlags ? parseArgument(value) : { kind: "operand", value });
  }

  return arguments_;
};

const parseRedirect = (redirect: BashRedirect): Redirect[] => {
  if (redirect.operator !== ">" || redirect.target === undefined) return [];

  return [{ operator: ">", target: { kind: "file", path: redirect.target.value } }];
};

function parseNestedCommands(word: Word): CommandLine {
  return (word.parts ?? []).flatMap((part) =>
    part.type === "CommandExpansion" && part.script !== undefined ? parseScript(part.script) : [],
  );
}

function parseNode(node: Node): CommandLine {
  if (node.type === "Pipeline" || node.type === "AndOr") return node.commands.flatMap(parseNode);
  if (node.type === "Subshell")
    return node.body.commands.flatMap((statement) => parseNode(statement.command));
  if (node.type !== "Command" || node.name === undefined) return [];

  const command = {
    program: node.name.value.split("/").pop() ?? "",
    arguments: parseArguments(node.suffix.map((word) => word.value)),
    redirects: node.redirects.flatMap(parseRedirect),
  };

  const nestedCommands = [node.name, ...node.suffix].flatMap(parseNestedCommands);
  return [command, ...nestedCommands];
}

function parseScript(script: ParsedScript): CommandLine {
  return script.commands.flatMap((statement) => parseNode(statement.command));
}

export const parseCommandLine = (commandLine: string): CommandLine =>
  parseScript(parse(commandLine));
