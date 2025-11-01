{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.media.enable {
    homebrew.casks = [
      "handbrake-app"
      "makemkv"
      "vlc"
    ];
  };
}
