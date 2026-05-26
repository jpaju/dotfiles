{
  config,
  lib,
  inputs,
  system,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    home.packages = [ inputs.llm-agents.packages.${system}.claude-code ];
    home.file."./claude/settings.json".source = ./settings.json;

    programs.fish.shellAbbrs = {
      cc = "claude";
      ccr = "claude --resume";
    };
  };
}
