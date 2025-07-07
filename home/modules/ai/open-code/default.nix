{ pkgs, config, ... }:
let
  opencode-wrapped = pkgs.writeShellScriptBin "opencode" ''
    export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets.anthropic_api_key.path})"
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
