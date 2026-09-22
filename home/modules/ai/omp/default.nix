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
    inputs.omp.homeManagerModules.default
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.omp = {
      enable = true;

      settings.tools.approvalMode = "write";

      package = pkgs.writeShellScriptBin "omp" ''
        export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
        export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
        export GEMINI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
        export GOOGLE_API_KEY="$GEMINI_API_KEY"

        exec ${inputs.llm-agents.packages.${system}.omp}/bin/omp "$@"
      '';
    };
  };
}
