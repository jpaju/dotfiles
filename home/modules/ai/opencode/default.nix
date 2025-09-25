{ pkgs, config, ... }:
{
  imports = [ ../../secrets/interface.nix ];

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
      autoupdate = false;
      share = "disabled";
      theme = "catppuccin";
      permission = {
        edit = "ask";
        bash = "ask";
        webfetch = "ask";
      };
    };
  };

}
