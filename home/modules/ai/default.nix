{ config, lib, ... }:
{
  imports = [
    ./commands
    ./mcp
    ./skills

    ./claude
    ./codex
    ./omp
    ./opencode
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    home.file.".agents/AGENTS.md".source = ./system-prompt.md;
  };
}
