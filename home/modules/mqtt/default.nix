{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.dotfiles.mqtt.enable {
    home.packages = [ pkgs.mqttui ];

    xdg.configFile."fish/functions/mqttui_connect.fish".source = ./mqttui_connect.fish;
  };
}
