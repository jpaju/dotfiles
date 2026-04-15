{
  config,
  lib,
  pkgs,
  llm-agents,
  ...
}:
{
  imports = [
    ../../secrets/interface.nix
    ./mcps
    ./permissions.nix
    ./plugins
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode = {
      enable = true;

      rules = ./rules.md;
      skills = ./skills;
      commands = ./commands;

      settings = {
        share = "disabled";
        autoupdate = false;
        theme = "catppuccin";

        default_agent = "plan";
        agent.explore.model = "anthropic/claude-sonnet-4-6";
      };

      package = pkgs.writeShellScriptBin "opencode" ''
        export OPENCODE_DISABLE_LSP_DOWNLOAD=true
        export OPENCODE_ENABLE_EXA=1

        export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
        export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
        export GOOGLE_GENERATIVE_AI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
        export CONTEXT7_API_KEY="$(cat ${config.secrets.context7_api_key})"

        exec ${llm-agents.opencode}/bin/opencode "$@"
      '';
    };

    programs.fish.shellAbbrs = {
      oc = "opencode";
      occ = "opencode --continue";
    };
  };
}
