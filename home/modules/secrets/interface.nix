/*
  Secrets interface module
  This module defines a backend-agnostic interface for accessing secrets.
  It abstracts away the underlying secrets management implementation (sops-nix, agenix, etc.)
  to provide a stable API for consumers.

  # Why this exists:
  - Decouples consumers from specific secrets backends
  - Enables easy switching between secrets management systems
  - Centralizes secret definitions in one place

  # Current implementation:
  - Uses sops-nix as the backend (implemented in sops.nix)
  - Provides file paths to decrypted secrets

  # To add new secrets:
  1. Add option definition to this file
  2. Define secret in backend-specific file, e.g. sops.nix

  # To change backends:
  Add new backend implementation (e.g., agenix.nix) that provides the same interface.
  Change will be transparent to consumers.
*/
{ lib, ... }:
{
  options.secrets = {
    anthropic_api_key = lib.mkOption {
      type = lib.types.str;
      description = "Path to the Anthropic API key file";
      readOnly = true;
    };

    copilot_api_key = lib.mkOption {
      type = lib.types.str;
      description = "Path to the GitHub Copilot API key file";
      readOnly = true;
    };
  };
}
