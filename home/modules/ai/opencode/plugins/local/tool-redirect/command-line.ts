import {
  parse,
  type ArithmeticFor as BashArithmeticFor,
  type AssignmentPrefix,
  type BraceGroup,
  type Case as BashCase,
  type Command as BashCommand,
  type Coproc as BashCoproc,
  type For as BashFor,
  type Function as BashFunction,
  type If as BashIf,
  type Node,
  type ParsedScript,
  type Redirect as BashRedirect,
  type Select as BashSelect,
  type Statement,
  type Subshell,
  type While as BashWhile,
  type Word,
  type WordPart,
} from "unbash";

// ================================= Domain model ==================================

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

// =============================== Argument parsing ================================

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

// =============================== Redirect parsing ================================

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

// ============================= Command expansions ================================

function parseCommandExpansionPart(part: WordPart): CommandLine {
  switch (part.type) {
    case "CommandExpansion":
      return part.script === undefined ? [] : parseScript(part.script);
    case "DoubleQuoted":
    case "LocaleString":
      return part.parts.flatMap(parseCommandExpansionPart);
    default:
      return [];
  }
}

const parseCommandExpansions = (word: Word): CommandLine =>
  (word.parts ?? []).flatMap(parseCommandExpansionPart);

const parseAssignmentExpansions = (assignment: AssignmentPrefix): CommandLine =>
  assignment.value === undefined ? [] : parseCommandExpansions(assignment.value);

const parseRedirectExpansions = (redirect: BashRedirect): CommandLine =>
  redirect.target === undefined ? [] : parseCommandExpansions(redirect.target);

// ============================== Concrete commands ================================

function parseCommand(commandNode: BashCommand): CommandLine {
  if (commandNode.name === undefined) return [];

  const command: Command = {
    program: commandNode.name.value.split("/").pop() ?? "",
    arguments: parseArguments(commandNode.suffix.map((word) => word.value)),
    redirects: commandNode.redirects.flatMap(parseRedirect),
  };

  const nestedCommands = [
    ...commandNode.prefix.flatMap(parseAssignmentExpansions),
    ...[commandNode.name, ...commandNode.suffix].flatMap(parseCommandExpansions),
    ...commandNode.redirects.flatMap(parseRedirectExpansions),
  ];
  return [command, ...nestedCommands];
}

// ============================== Compound commands ================================

const parseSubshell = (subshell: Subshell): CommandLine => parseStatements(subshell.body.commands);

const parseBraceGroup = (braceGroup: BraceGroup): CommandLine =>
  parseStatements(braceGroup.body.commands);

function parseIf(ifNode: BashIf): CommandLine {
  const commands = [
    ...parseStatements(ifNode.clause.commands),
    ...parseStatements(ifNode.then.commands),
  ];

  if (ifNode.else === undefined) return commands;
  const elseCommands =
    ifNode.else.type === "If" ? parseIf(ifNode.else) : parseStatements(ifNode.else.commands);
  return [...commands, ...elseCommands];
}

const parseFor = (forNode: BashFor): CommandLine => parseStatements(forNode.body.commands);

const parseArithmeticFor = (forNode: BashArithmeticFor): CommandLine =>
  parseStatements(forNode.body.commands);

const parseSelect = (selectNode: BashSelect): CommandLine =>
  parseStatements(selectNode.body.commands);

const parseWhile = (whileNode: BashWhile): CommandLine => [
  ...parseStatements(whileNode.clause.commands),
  ...parseStatements(whileNode.body.commands),
];

const parseCase = (caseNode: BashCase): CommandLine =>
  caseNode.items.flatMap((item) => parseStatements(item.body.commands));

const parseFunction = (functionNode: BashFunction): CommandLine => parseNode(functionNode.body);

const parseCoproc = (coprocNode: BashCoproc): CommandLine => parseNode(coprocNode.body);

// ================================ AST traversal ==================================

const PARSE_FAILURE = Symbol("PARSE_FAILURE");

const parseCommandSequence = (nodes: Node[]): CommandLine => nodes.flatMap(parseNode);

const parseStatements = (statements: Statement[]): CommandLine =>
  statements.flatMap((s) => parseNode(s.command));

function parseNode(node: Node): CommandLine {
  switch (node.type) {
    case "Pipeline":
    case "AndOr":
      return parseCommandSequence(node.commands);
    case "Subshell":
      return parseSubshell(node);
    case "BraceGroup":
      return parseBraceGroup(node);
    case "If":
      return parseIf(node);
    case "For":
      return parseFor(node);
    case "ArithmeticFor":
      return parseArithmeticFor(node);
    case "Select":
      return parseSelect(node);
    case "While":
      return parseWhile(node);
    case "Case":
      return parseCase(node);
    case "Function":
      return parseFunction(node);
    case "Coproc":
      return parseCoproc(node);
    case "Command":
      return parseCommand(node);
    default:
      return [];
  }
}

const parseScript = (script: ParsedScript): CommandLine => {
  if (script.errors !== undefined && script.errors.length > 0) throw PARSE_FAILURE;
  return parseStatements(script.commands);
};

// ================================= Public API ====================================

export const parseCommandLine = (commandLine: string): CommandLine => {
  try {
    return parseScript(parse(commandLine));
  } catch (error) {
    if (error === PARSE_FAILURE) return [];
    throw error;
  }
};
