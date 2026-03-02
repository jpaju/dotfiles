{ config, lib, ... }:
{
  config = lib.mkIf (config.dotfiles.browsers != [ ]) {
    homebrew.casks = config.dotfiles.browsers;
  };
}
