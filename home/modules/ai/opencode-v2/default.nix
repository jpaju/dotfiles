{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
{
  imports = [ ../../secrets/interface.nix ];

  config = lib.mkIf config.dotfiles.ai.enable {
    home.packages =
      let
        opencode2 = pkgs.writeShellScriptBin "opencode2" ''
          # Isolate v2 from v1's configuration, database, cache and background
          # service state so using v2 won't migrate or overwrite v1's data.
          root="$HOME/.local/share/opencode-v2"
          export XDG_CONFIG_HOME="$root/config"
          export XDG_DATA_HOME="$root/data"
          export XDG_CACHE_HOME="$root/cache"
          export XDG_STATE_HOME="$root/state"
          export OPENCODE_CONFIG_DIR="$XDG_CONFIG_HOME/opencode"

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
      [ opencode2 ];

    programs.fish.shellAbbrs = {
      oc2 = "opencode2";
      occ2 = "opencode2 --continue";
    };
  };
}
