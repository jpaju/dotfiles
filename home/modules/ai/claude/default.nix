{
  config,
  lib,
  nix-ai-tools,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    home.packages = [ nix-ai-tools.claude-code ];
    home.file."./claude/settings.json".source = ./settings.json;

    programs.fish.shellAbbrs = {
      cc = "claude";
      ccr = "claude --resume";
    };
  };
}
