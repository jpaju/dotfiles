{
  config,
  lib,
  llm-agents,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    home.packages = [ llm-agents.claude-code ];
    home.file."./claude/settings.json".source = ./settings.json;

    programs.fish.shellAbbrs = {
      cc = "claude";
      ccr = "claude --resume";
    };
  };
}
