{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.dotfiles.kafka.enable {
    home.packages = [ pkgs.kcat ];
  };
}
