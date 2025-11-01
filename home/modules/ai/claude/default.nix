{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    home.packages = [ pkgs.claude-code ];
    home.file."./claude/settings.json".source = ./settings.json;

    programs.fish.shellAbbrs = {
      cc = "claude";
      ccr = "claude --resume";
    };
  };
}
