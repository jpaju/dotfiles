{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.remote-access.enable {
    homebrew.casks = [ "teamviewer" ];
  };
}
