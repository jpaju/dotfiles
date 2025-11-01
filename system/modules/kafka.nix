{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.kafka.enable {
    homebrew.taps = [ "xitonix/trubka" ];
    homebrew.brews = [ "trubka" ];
  };
}
