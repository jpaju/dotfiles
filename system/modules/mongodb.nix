{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.mongodb.enable {
    homebrew.casks = [ "mongodb-compass" ];
  };
}
