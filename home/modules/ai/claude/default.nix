{
  config,
  lib,
  inputs,
  system,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.claude-code = {
      enable = true;
      package = inputs.llm-agents.packages.${system}.claude-code;

      settings = {
        tui = "fullscreen";

        env.DISABLE_UPDATES = "1";

        permissions.allow = [
          "WebFetchTool"
          "WebSearch"
        ];
      };
    };

    programs.fish.shellAbbrs = {
      cc = "claude";
      ccr = "claude --resume";
    };
  };
}
