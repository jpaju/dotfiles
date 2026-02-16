{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.wolt-tools.enable {
    # AWS SSO configuration
    programs.fish = {
      shellInit = "aws-sso-configurator completion fish | source";
      shellAbbrs.asso = "aws-sso-configurator";
    };

    home.packages =
      let
        jiraWrapped = pkgs.writeShellScriptBin "jira" ''
          export JIRA_API_TOKEN="$(op read "op://Private/7372wd5ekuqogdq3btpe7ncuyi/credential")"
          exec ${pkgs.jira-cli-go}/bin/jira "$@"
        '';
      in
      with pkgs;
      [
        gnupg
        jiraWrapped
        vault
      ];
  };
}
