import { describe, expect, test } from "bun:test";

import { parseCommandLine } from "./command-line";

describe("parseCommandLine", () => {
  test("parses a simple command", () => {
    expect(parseCommandLine("/usr/bin/git status --short")).toEqual([
      {
        program: "git",
        arguments: [
          { kind: "operand", value: "status" },
          { kind: "flag", name: "--short" },
        ],
        redirects: [],
      },
    ]);
  });
});
