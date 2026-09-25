import {
  parse,
  type Command as BashCommand,
  type Node,
  type ParsedScript,
  type Redirect as BashRedirect,
  type Statement,
  type Subshell,
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

const parseStdio = (descriptor: string): Stdio | undefined => {
  switch (descriptor) {
    case "0":
      return "stdin";
    case "1":
      return "stdout";
    case "2":
      return "stderr";
    default:
      return undefined;
  }
};

const parseRedirect = (redirect: BashRedirect): Redirect[] => {
  if (redirect.target === undefined) return [];

  if (redirect.operator === ">&") {
    const stdio = parseStdio(redirect.target.value);
    if (stdio !== undefined) return [{ operator: ">&", target: { kind: "stdio", stdio } }];
  }

  switch (redirect.operator) {
    case ">":
    case ">>":
    case ">|":
    case "&>":
    case "&>>":
    case ">&":
    case "<>":
      return [
        {
          operator: redirect.operator,
          target: { kind: "file", path: redirect.target.value },
        },
      ];
    default:
      return [];
  }
};

const parseCommandExpansions = (word: Word): CommandLine =>
  (word.parts ?? []).flatMap((part) =>
    part.type === "CommandExpansion" && part.script !== undefined ? parseScript(part.script) : [],
  );

function parseCommand(commandNode: BashCommand): CommandLine {
  if (commandNode.name === undefined) return [];

  const command: Command = {
    program: commandNode.name.value.split("/").pop() ?? "",
    arguments: parseArguments(commandNode.suffix.map((word) => word.value)),
    redirects: commandNode.redirects.flatMap(parseRedirect),
  };

  const nestedCommands = [commandNode.name, ...commandNode.suffix].flatMap(parseCommandExpansions);
  return [command, ...nestedCommands];
}

const parseCommandSequence = (nodes: Node[]): CommandLine => nodes.flatMap(parseNode);

const parseStatements = (statements: Statement[]): CommandLine =>
  statements.flatMap((s) => parseNode(s.command));

const parseSubshell = (subshell: Subshell): CommandLine => parseStatements(subshell.body.commands);

function parseNode(node: Node): CommandLine {
  switch (node.type) {
    case "Pipeline":
    case "AndOr":
      return parseCommandSequence(node.commands);
    case "Subshell":
      return parseSubshell(node);
    case "Command":
      return parseCommand(node);
    default:
      return [];
  }
}

const parseScript = (script: ParsedScript): CommandLine => parseStatements(script.commands);

export const parseCommandLine = (commandLine: string): CommandLine =>
  parseScript(parse(commandLine));
