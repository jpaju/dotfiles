{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../../secrets/interface.nix ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.fish.shellAbbrs.oc = "opencode";

    programs.opencode = {
      enable = true;

      package = pkgs.writeShellScriptBin "opencode" ''
        export OPENCODE_DISABLE_LSP_DOWNLOAD=true

        export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
        export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"

        exec ${pkgs.opencode}/bin/opencode "$@"
      '';

      settings = {
        theme = "catppuccin";

        share = "disabled";
        autoupdate = false;

        permission = {
          edit = "ask";
          webfetch = "allow";
          bash = {
            "*" = "ask";
            "ls" = "allow";
            "pwd" = "allow";
            "grep" = "allow";
            "rg" = "allow";
            "git status" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git blame *" = "allow";
          };
        };
      };
    };
  };
}
