{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.wolt-tools.enable {
    homebrew = {
      casks = [ "cloudflare-warp" ];

      taps = [
        {
          name = "creditornot/homebrew-wolt-dev-tools";
          clone_target = "git@github.com:creditornot/homebrew-wolt-dev-tools.git";
        }
      ];

      brews = [ "aws-sso-configurator" ];
    };
  };
}
