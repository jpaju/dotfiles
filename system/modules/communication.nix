{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.communication.enable {
    homebrew.casks = [
      "signal"
    ];
  };
}
