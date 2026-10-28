import { expect, test } from "bun:test";
import { Agent } from "@opencode/plugin/effect";
import type { ToolHooks } from "@opencode/plugin/effect/tool";
import * as Tool from "@opencode/plugin/promise/tool";
import { Session } from "@opencode/schema/session";
import { SessionMessage } from "@opencode/schema/session-message";
import { Effect } from "effect";
import plugin from "./plugin";
import { toolHookContext } from "./test-context";

type CapturedHook = () => Effect.Effect<void, Tool.Error>;

const executeBefore = (command: unknown, tool = "shell") =>
  Effect.scoped(
    Effect.gen(function* () {
      const before: ToolHooks["execute.before"] = {
        tool,
        input: { command },
        sessionID: Session.ID.make("ses_test"),
        agent: Agent.ID.make("build"),
        messageID: SessionMessage.ID.make("msg_test"),
        id: Tool.CallID.make("call_test"),
      };
      const events: ToolHooks = {
        "execute.before": before,
        "execute.after": { ...before, status: "completed", result: { content: "unused" } },
      };
      const callbacks: CapturedHook[] = [];
      const context = toolHookContext((name, callback) =>
        Effect.sync(() => {
          expect<string>(name).toBe("execute.before");
          callbacks.push(() => callback(events[name]));
          return { dispose: Effect.void };
        }),
      );

      yield* plugin.effect(context);
      expect(callbacks).toHaveLength(1);
      const [runHook] = callbacks;
      if (!runHook) throw new Error("Plugin did not register a tool hook");
      yield* runHook();
    }),
  );

test("blocks find with a typed failure, alternative and bypass instructions", () => {
  const error = Effect.runSync(Effect.flip(executeBefore("find . -name '*.nix'")));
  expect(error).toBeInstanceOf(Tool.Error);
  expect(error.message).toContain("Blocked: `find` → use the Glob tool.");
  expect(error.message).toContain('OC_BYPASS_TOOL_REDIRECT="<reason>"');
});

test("allows ordinary shell commands", () => {
  expect(Effect.runSync(executeBefore("git status --short"))).toBeUndefined();
});

test("allows an explicit bypass", () => {
  expect(Effect.runSync(executeBefore(
    'OC_BYPASS_TOOL_REDIRECT="needs find -exec" find . -type f',
  ))).toBeUndefined();
});

test("ignores other tools", () => {
  expect(Effect.runSync(executeBefore("find .", "read"))).toBeUndefined();
});

test.each([undefined, null, 42])("rejects invalid shell command %p with a typed failure", (command) => {
  const error = Effect.runSync(Effect.flip(executeBefore(command)));
  expect(error).toBeInstanceOf(Tool.Error);
  expect(error.message).toBe("Shell tool input must contain a string command");
});
