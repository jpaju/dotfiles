# Tool redirect

An OpenCode plugin that redirects common shell commands to safer alternatives.

| Command  | Redirect to                                     |
| -------- | ----------------------------------------------- |
| `find`   | Glob tool                                       |
| `curl`   | WebFetch tool                                   |
| `git -C` | `workdir` parameter on Bash tool                |
| `cd`     | `workdir` or `path` parameter on built-in tools |
| `man`    | context7 MCP                                    |
| `--help` | context7 MCP                                    |

## Why

LLMs often reach for familiar shell commands even when safer built-in alternatives exist. Some shell commands can be dangerous. For example, `find -exec rm -rf` could delete files across the entire project, so they should require explicit user approval before running. With OpenCode [permissions](https://opencode.ai/docs/permissions/), you can enforce this, but every unapproved command then requires constant manual oversight.

Built-in tools are scoped to their specific purpose and cannot cause unintended side effects, so they can safely run without approval. Redirecting shell commands to their built-in equivalents lets the agent work autonomously for common operations, without requiring manual review every step of the way.

## How it works

When the Bash tool is called, the plugin checks whether the command contains any redirectable programs. If it does, it blocks the execution and instructs the agent to use the built-in equivalent instead.

There are legitimate cases where built-in tools fall short, such as complex piped commands or advanced `find` chains. The plugin provides an escape hatch for those situations, allowing the agent to proceed as long as it provides an explicit reason.
