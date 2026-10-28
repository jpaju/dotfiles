import type { Plugin } from "@opencode/plugin/effect";
import type { ToolDomain } from "@opencode/plugin/effect/tool";

const unexpected = (name: string): never => {
  throw new Error(`Unexpected plugin context access: ${name}`);
};

export const toolHookContext = (hook: ToolDomain["hook"]): Plugin.Context => ({
  tool: {
    hook,
    list: () => unexpected("tool.list"),
    reload: () => unexpected("tool.reload"),
    transform: () => unexpected("tool.transform"),
  },
  get app() {
    return unexpected("app");
  },
  get location() {
    return unexpected("location");
  },
  get options() {
    return unexpected("options");
  },
  get agent() {
    return unexpected("agent");
  },
  get aisdk() {
    return unexpected("aisdk");
  },
  get command() {
    return unexpected("command");
  },
  get credential() {
    return unexpected("credential");
  },
  get event() {
    return unexpected("event");
  },
  get experimental() {
    return unexpected("experimental");
  },
  get integration() {
    return unexpected("integration");
  },
  get mcp() {
    return unexpected("mcp");
  },
  get model() {
    return unexpected("model");
  },
  get generate() {
    return unexpected("generate");
  },
  get permission() {
    return unexpected("permission");
  },
  get plugin() {
    return unexpected("plugin");
  },
  get provider() {
    return unexpected("provider");
  },
  get reference() {
    return unexpected("reference");
  },
  get rpc() {
    return unexpected("rpc");
  },
  get session() {
    return unexpected("session");
  },
  get shell() {
    return unexpected("shell");
  },
  get skill() {
    return unexpected("skill");
  },
  get storage() {
    return unexpected("storage");
  },
  get vcs() {
    return unexpected("vcs");
  },
  get websearch() {
    return unexpected("websearch");
  },
  get worktree() {
    return unexpected("worktree");
  },
});
