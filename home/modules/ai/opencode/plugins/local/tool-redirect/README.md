# Command safety gate

An OpenCode plugin that lets agents run autonomously while staying safe.

## Vision

Give agents **autonomy with safety**: let them run as freely as possible without manual oversight, while guaranteeing they cannot modify state (delete or change files, or cause other side effects) without explicit human approval.

OpenCode already ships a [permissions](https://opencode.ai/docs/permissions/) system that decides allow/ask/deny by matching **command-prefix globs** (e.g. "`find *` is allowed"). It cannot inspect the internal structure of a command, so a command that is safe in its common form becomes dangerous through its **arguments or its redirections**, and permissions are blind to that distinction:

- `find` is harmless for listing, but `find ... -exec <anything>` can run arbitrary commands.
- `sed file` reads; `sed -i file` rewrites the file in place.
- `cmd > /dev/null` discards output; `cmd > important.txt` overwrites a file.

This plugin **complements** permissions; it does not replace them. Permissions stay broad and convenient (allow `find`, `sed`, `rg`, etc. outright); the plugin inspects the structure they can't see and requires approval for the dangerous variants those broad rules would otherwise let through. It only adds restrictions, and never overrides a permission `deny`.

## What "safe" means

A command is **safe** (may run autonomously) when it cannot modify state:

- Reading files, listing directories, searching, inspecting.
- Writing to discard sinks such as `/dev/null`.
- Stream redirection that does not write to a real file (e.g. redirecting stderr to stdout).

A command is **unsafe** (requires manual approval) when it can modify state, whether on the local filesystem or on an external system:

- Deleting or modifying files or directories.
- Executing arbitrary sub-commands whose effects cannot be reasoned about (e.g. `find -exec`).
- Redirecting output to a real file (truncating or appending).
- Mutating an external datastore, e.g. a write query through `psql`.
- Performing non-read-only operations against infrastructure, e.g. `kubectl` actions that create, modify, or delete resources.
- Sending data over the network with a network-capable tool, e.g. `curl`.
