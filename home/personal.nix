{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  home.packages = [ pkgs.mqttui ];
}
