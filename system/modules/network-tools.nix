{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.network-tools.enable {
    homebrew.casks = [
      "winbox"
      "wireshark-app"
    ];
  };
}
