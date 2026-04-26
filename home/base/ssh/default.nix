{ config, lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    }
    // lib.optionalAttrs config.dotfiles.homelab.enable {
      "home-automation" = {
        hostname = "home-automation.int.jpaju.fi";
        user = "jaakko";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        sendEnv = [ "COLORTERM" ];
      };

      "media-server" = {
        hostname = "media-server.int.jpaju.fi";
        user = "jaakko";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        sendEnv = [ "COLORTERM" ];
      };
    };
  };
}
