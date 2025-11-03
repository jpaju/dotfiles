{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.work-vpn.enable {
    homebrew.casks = [ "cloudflare-warp" ];
  };
}
