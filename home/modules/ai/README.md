# AI harnesses

## Goal

Define AI configuration once and share it across all harnesses: Claude Code, Codex, OpenCode and oh-my-pi (omp).

## Approach

- Shared definitions live in one place, in our own format
- Each harness module renders the shared definitions into its own config format
- omp reads the OpenCode config instead of getting its own, enabled with `enabledProviders = [ "opencode" ]`
- Secrets are declared next to what needs them, and all harnesses pick them up automatically

## Status

| Topic       | Status                                                       |
| ----------- | ------------------------------------------------------------ |
| MCPs        | In progress: Claude and OpenCode done, Codex verifying       |
| Skills      | In progress: Claude, OpenCode and omp done, Codex has issues |
| Commands    | Done: Claude, OpenCode and omp. Codex has no custom commands |
| Permissions | Not started                                                  |

## Decisions and limitations

- Home Manager's native MCP integration was tried and dropped: harnesses use different env var syntax in headers
- Claude can't disable individual MCP servers, so all servers are enabled there
- Codex can't enable MCP servers interactively within a session, so all servers are enabled there
- Some skills are worded around OpenCode's bash permission allowlist. Revisit them when permissions are shared

## Way of working

- One step at a time, verify each harness before moving on
- OpenCode is migrated last, as it is the main harness
