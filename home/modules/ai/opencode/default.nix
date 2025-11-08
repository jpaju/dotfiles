{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../../secrets/interface.nix ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.fish.shellAbbrs = {
      oc = "opencode";
      occ = "opencode --continue";
    };

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
            "head" = "allow";
            "tail" = "allow";
            "wc" = "allow";
            "cat" = "allow";
            "grep" = "allow";
            "rg" = "allow";
            "git status" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git blame *" = "allow";
            "gh pr list *" = "allow";
            "gh pr view *" = "allow";
            "gh pr diff *" = "allow";
            "gh pr checks *" = "allow";
          };
        };
      };
    };
  };
}
