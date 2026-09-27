# AI harnesses

## Goal

Define AI configuration once and share it across all harnesses: Claude Code, Codex, OpenCode and oh-my-pi (omp).

## Approach

- Shared definitions live in one place, in our own format
- Each harness module renders the shared definitions into its own config format
- omp reads the OpenCode config instead of getting its own, enabled with `enabledProviders = [ "opencode" ]`
- Secrets are declared next to what needs them, and all harnesses pick them up automatically

## Status

| Topic       | Status                                                               |
| ----------- | -------------------------------------------------------------------- |
| MCPs        | In progress: Claude done, Codex verifying, OpenCode last             |
| Permissions | Not started                                                          |
| Skills      | Not started                                                          |

## Decisions and limitations

- Home Manager's native MCP integration was tried and dropped: harnesses use different env var syntax in headers
- Claude can't disable individual MCP servers, so all servers are enabled there
- Codex can't enable MCP servers interactively within a session, so all servers are enabled there

## Way of working

- One step at a time, verify each harness before moving on
- OpenCode is migrated last, as it is the main harness
