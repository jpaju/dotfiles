{ pkgs, config, ... }:
let
  opencode-wrapped = pkgs.writeShellScriptBin "opencode" ''
    export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
in {
  programs.opencode = {
    enable = true;
    package = opencode-wrapped;
    settings = {
      autoshare = false;
      autoupdate = true;
      theme = "tokyonight";
    };
  };

  programs.fish.shellAbbrs.oc = "opencode";
}
