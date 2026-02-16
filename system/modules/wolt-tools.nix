{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.wolt-tools.enable {
    homebrew.casks = [ "cloudflare-warp" ];
  };
}
