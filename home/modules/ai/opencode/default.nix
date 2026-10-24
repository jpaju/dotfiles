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
    ./skills.nix
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode = {
      enable = true;
      mutableSettings = true;

      context = ./system-prompt.md;
      commands = ./commands;

      settings = {
        share = "disabled";
        autoupdate = false;
        default_agent = "plan";
        websearch.provider = "exa";
        policies = [
          {
            action = "integration.use";
            resource = "plugin:*";
            effect = "deny";
          }
        ];
      };

      cli = {
        theme.name = "catppuccin";
        animations = true;
        session.scrollbar = true;
        tabs = {
          mode = "on";
          scope = "cwd";
          layout = "horizontal";
        };
        attention = {
          notifications = false;
          sound = false;
        };
      };

      package =
        let
          version = inputs.llm-agents.packages.${system}.opencode2.version;
          wrapper = pkgs.writeShellScriptBin "opencode" ''
            export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
            export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
            export GOOGLE_GENERATIVE_AI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
            export CONTEXT7_API_KEY="$(cat ${config.secrets.context7_api_key})"
            ${lib.optionalString config.dotfiles.ai.work-mcps.enable ''
              export ROOTLY_API_KEY="$(cat ${config.secrets.rootly_api_key})"
            ''}

            exec ${inputs.llm-agents.packages.${system}.opencode2}/bin/opencode2 "$@"
          '';
        in
        # Home Manager needs the version to recognize v2 CLI configuration support
        wrapper // { version = version; };
    };

    programs.fish.shellAbbrs = {
      oc = "opencode";
      occ = "opencode --continue";
    };
  };
}
