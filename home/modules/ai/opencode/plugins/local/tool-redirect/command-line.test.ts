import { describe, expect, test } from "bun:test";

import { CommandLine, parseCommandLine, type RedirectOperator, type Stdio } from "./command-line";

describe("parseCommandLine", () => {
  test("parses a simple command", () => {
    const actual = parseCommandLine("/usr/bin/git status --short");

    const expected = {
      program: "git",
      arguments: [
        { kind: "operand", value: "status" },
        { kind: "flag", name: "--short" },
      ],
      redirects: [],
    };

    expect(actual).toEqual([expected]);
  });

  test("normalizes a long flag with an attached value", () => {
    const actual = parseCommandLine("sort --output=result.txt input.txt");

    const expected = {
      program: "sort",
      arguments: [
        { kind: "flag", name: "--output" },
        { kind: "operand", value: "input.txt" },
      ],
      redirects: [],
    };

    expect(actual).toEqual([expected]);
  });

  test("treats arguments after -- as operands", () => {
    const actual = parseCommandLine("sed -- -i");

    const expected = {
      program: "sed",
      arguments: [{ kind: "operand", value: "-i" }],
      redirects: [],
    };

    expect(actual).toEqual([expected]);
  });

  test("uses dequoted argument values", () => {
    const actual = parseCommandLine('rg "foo bar" file\\ name');

    const expected = {
      program: "rg",
      arguments: [
        { kind: "operand", value: "foo bar" },
        { kind: "operand", value: "file name" },
      ],
      redirects: [],
    };

    expect(actual).toEqual([expected]);
  });

  test("flattens semicolon and newline-separated commands", () => {
    const actual = parseCommandLine("pwd; git status\nrg foo");

    const expected = [
      { program: "pwd", arguments: [], redirects: [] },
      {
        program: "git",
        arguments: [{ kind: "operand", value: "status" }],
        redirects: [],
      },
      {
        program: "rg",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
    ];

    expect(actual).toEqual(expected);
  });

  test("flattens pipeline commands", () => {
    const actual = parseCommandLine("printf foo | rg foo");

    const expected = [
      {
        program: "printf",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
      {
        program: "rg",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
    ];

    expect(actual).toEqual(expected);
  });

  test("flattens logical command chains", () => {
    const actual = parseCommandLine("git status && rg foo || pwd");

    const expected = [
      {
        program: "git",
        arguments: [{ kind: "operand", value: "status" }],
        redirects: [],
      },
      {
        program: "rg",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
      { program: "pwd", arguments: [], redirects: [] },
    ];

    expect(actual).toEqual(expected);
  });

  test("flattens commands inside a subshell", () => {
    const actual = parseCommandLine("(git status; rg foo)");

    const expected = [
      {
        program: "git",
        arguments: [{ kind: "operand", value: "status" }],
        redirects: [],
      },
      {
        program: "rg",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
    ];

    expect(actual).toEqual(expected);
  });

  test("flattens commands inside a command substitution", () => {
    const actual = parseCommandLine("cd $(git rev-parse --show-toplevel)");

    const expected = [
      {
        program: "cd",
        arguments: [{ kind: "operand", value: "$(git rev-parse --show-toplevel)" }],
        redirects: [],
      },
      {
        program: "git",
        arguments: [
          { kind: "operand", value: "rev-parse" },
          { kind: "flag", name: "--show-toplevel" },
        ],
        redirects: [],
      },
    ];

    expect(actual).toEqual(expected);
  });

  test("parses an output file redirect", () => {
    const actual = parseCommandLine("gh repo --help > gh-help.txt");

    const expected = {
      program: "gh",
      arguments: [
        { kind: "operand", value: "repo" },
        { kind: "flag", name: "--help" },
      ],
      redirects: [{ operator: ">", target: { kind: "file", path: "gh-help.txt" } }],
    };

    expect(actual).toEqual([expected]);
  });

  test("parses >> as an output file redirect", () => expectOutputFileRedirect(">>"));
  test("parses >| as an output file redirect", () => expectOutputFileRedirect(">|"));
  test("parses &> as an output file redirect", () => expectOutputFileRedirect("&>"));
  test("parses &>> as an output file redirect", () => expectOutputFileRedirect("&>>"));
  test("parses >& as an output file redirect", () => expectOutputFileRedirect(">&"));
  test("parses <> as an output file redirect", () => expectOutputFileRedirect("<>"));

  test("parses a redirect to stdin", () => expectStdioRedirect("0", "stdin"));
  test("parses a redirect to stdout", () => expectStdioRedirect("1", "stdout"));
  test("parses a redirect to stderr", () => expectStdioRedirect("2", "stderr"));

  test("ignores an input file redirect", () => {
    const actual = parseCommandLine("cat < input.txt");

    const expected = {
      program: "cat",
      arguments: [],
      redirects: [],
    };

    expect(actual).toEqual([expected]);
  });

  test("ignores an input descriptor redirect", () => {
    const actual = parseCommandLine("cat <&0");

    const expected = {
      program: "cat",
      arguments: [],
      redirects: [],
    };

    expect(actual).toEqual([expected]);
  });

  test("ignores the source file descriptor", () => {
    const actual = parseCommandLine("cargo build 2> errors.txt");

    const expected = {
      program: "cargo",
      arguments: [{ kind: "operand", value: "build" }],
      redirects: [{ operator: ">", target: { kind: "file", path: "errors.txt" } }],
    };

    expect(actual).toEqual([expected]);
  });

  test("preserves an absolute file redirect target", () => {
    const actual = parseCommandLine("npm test 2> /tmp/npm-errors.log");

    const expected = {
      program: "npm",
      arguments: [{ kind: "operand", value: "test" }],
      redirects: [{ operator: ">", target: { kind: "file", path: "/tmp/npm-errors.log" } }],
    };

    expect(actual).toEqual([expected]);
  });

  test("returns no commands when parsing fails", () => {
    const actual = parseCommandLine("git status |");

    const expected: CommandLine = [];

    expect(actual).toEqual(expected);
  });

  test("flattens commands inside a brace group", () => {
    const actual = parseCommandLine("{ git status; rg foo; }");

    const expected = [
      {
        program: "git",
        arguments: [{ kind: "operand", value: "status" }],
        redirects: [],
      },
      {
        program: "rg",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
    ];

    expect(actual).toEqual(expected);
  });

  test("flattens commands inside an if statement", () => {
    const actual = parseCommandLine("if git status; then rg foo; else pwd; fi");

    const expected = [
      {
        program: "git",
        arguments: [{ kind: "operand", value: "status" }],
        redirects: [],
      },
      {
        program: "rg",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
      { program: "pwd", arguments: [], redirects: [] },
    ];

    expect(actual).toEqual(expected);
  });

  test("flattens commands inside a for loop", () => {
    const actual = parseCommandLine('for file in a b; do cat "$file"; done');

    const expected = {
      program: "cat",
      arguments: [{ kind: "operand", value: "$file" }],
      redirects: [],
    };

    expect(actual).toEqual([expected]);
  });

  test("flattens commands inside a while loop", () => {
    const actual = parseCommandLine("while git status; do rg foo; done");

    const expected = [
      {
        program: "git",
        arguments: [{ kind: "operand", value: "status" }],
        redirects: [],
      },
      {
        program: "rg",
        arguments: [{ kind: "operand", value: "foo" }],
        redirects: [],
      },
    ];

    expect(actual).toEqual(expected);
  });
});

const expectOutputFileRedirect = (operator: RedirectOperator): void => {
  const actual = parseCommandLine(`printf foo ${operator} output.txt`);

  const expected = {
    program: "printf",
    arguments: [{ kind: "operand", value: "foo" }],
    redirects: [{ operator, target: { kind: "file", path: "output.txt" } }],
  };

  expect(actual).toEqual([expected]);
};

const expectStdioRedirect = (descriptor: string, stdio: Stdio): void => {
  const actual = parseCommandLine(`cargo test 2>&${descriptor}`);

  const expected = {
    program: "cargo",
    arguments: [{ kind: "operand", value: "test" }],
    redirects: [{ operator: ">&", target: { kind: "stdio", stdio } }],
  };

  expect(actual).toEqual([expected]);
};
