---
name: nix
description: MUST load BEFORE running any `nix` or `nix-*` CLI command.
---

# Nix

Conventions for using the Nix CLI. Prefer the modern unified `nix <cmd>` form over legacy `nix-<cmd>` commands. The available commands and their flags vary by Nix version and installation; rely on `nix help` to discover them on demand rather than memorizing or guessing.

## Discovering commands

- `nix help` lists all top-level subcommands.
- `nix help <subcommand>` shows full reference: synopsis, examples, options.
- Some subcommands group further subcommands; `nix help <subcommand>` will list them, and `nix help <subcommand> <sub>` drills into a specific one.

## Environment

- `nix-command` and `flakes` experimental features are enabled globally. Don't explicitly pass `--experimental-features`

## Evaluation and builds

Prefer `nix-inspect` for evaluation and builds to preserve autonomous operation without manual permission approvals. Its supported commands are pre-approved and enforce fixed defaults. Invoke the installed command directly; calling its script through `bash` or an absolute path misses the permission allowance. Separate external-directory permissions still apply.

- Evaluation: `nix-inspect eval <installable>`, `nix-inspect eval --expr EXPR`, or `nix-inspect eval --file PATH`. Exactly one input.
- Supported flags and options: `--raw`, `--json`, `--apply FUNCTION`, `--impure`, and `--no-write-lock-file`. Refer to `nix help eval` for their semantics. Options may appear before or after the input; `--` terminates option parsing.
- Evaluation always enforces read-only mode, no lock-file writes, and disabled import from derivation and unsafe native evaluation.
- Builds: `nix-inspect build <installable>`, with fixed `--no-link --print-out-paths`.
- Use direct `nix eval` or `nix build` only for unsupported operations. Do not bypass blocked import from derivation through direct evaluation.

## Restrictions

- Don't run commands that rebuild or activate system/user configuration (`nixos-rebuild`, `darwin-rebuild`, `home-manager switch`, etc.). Ask the user to run them.
- Never recursively search `/nix/store`; resolve and inspect a specific store path instead.
