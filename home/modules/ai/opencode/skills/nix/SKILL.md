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

## Restrictions

- Don't run commands that rebuild or activate system/user configuration (`nixos-rebuild`, `darwin-rebuild`, `home-manager switch`, etc.). Ask the user to run them.
