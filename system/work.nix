{ ... }:
{

  imports = [ ./common.nix ];

  homebrew.casks = [
    "cloudflare-warp" # VPN client
    "mongodb-compass" # UI for MongoDB
  ];

}
