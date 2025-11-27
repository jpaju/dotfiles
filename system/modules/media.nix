{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.media.enable {
    homebrew.casks = [
      "bluos-controller"
      "handbrake-app"
      "makemkv"
      "vlc"
    ];
  };
}
