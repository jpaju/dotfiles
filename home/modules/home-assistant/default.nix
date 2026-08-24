{
  config,
  lib,
  pkgs,
  ...
}:
let
  hass-cli = pkgs.symlinkJoin {
    name = "homeassistant-cli";
    paths = [ pkgs.home-assistant-cli ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/hass-cli \
        --run 'export HASS_SERVER="$(cat ${config.secrets.hass_server})"' \
        --run 'export HASS_TOKEN="$(cat ${config.secrets.hass_token})"'
    '';
  };
in
{
  config = lib.mkIf config.dotfiles.home-assistant.enable {
    home.packages = [ hass-cli ];
  };
}
