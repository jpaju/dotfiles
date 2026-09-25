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
});
