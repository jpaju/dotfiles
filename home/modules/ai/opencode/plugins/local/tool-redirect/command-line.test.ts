import { describe, expect, test } from "bun:test";

import { parseCommandLine } from "./command-line";

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
});
