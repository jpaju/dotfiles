{
  config,
  lib,
  pkgs,
  inputs,
  system,
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

      context = ./system-prompt.md;
      skills = ./skills;
      commands = ./commands;

      settings = {
        share = "disabled";
        autoupdate = false;
        theme = "catppuccin";
        default_agent = "plan";
      };

      package = pkgs.writeShellScriptBin "opencode" ''
        export OPENCODE_DISABLE_LSP_DOWNLOAD=true
        export OPENCODE_ENABLE_EXA=1

        export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
        export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
        export GOOGLE_GENERATIVE_AI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
        export CONTEXT7_API_KEY="$(cat ${config.secrets.context7_api_key})"
        ${lib.optionalString config.dotfiles.ai.work-mcps.enable ''
          export ROOTLY_API_KEY="$(cat ${config.secrets.rootly_api_key})"
        ''}

        exec ${inputs.llm-agents.packages.${system}.opencode}/bin/opencode "$@"
      '';
    };

    programs.fish.shellAbbrs = {
      oc = "opencode";
      occ = "opencode --continue";
    };
  };
}
