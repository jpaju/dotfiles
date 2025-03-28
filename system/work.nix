{ ... }: {

  imports = [ ./common.nix ];

  homebrew = {
    taps = [ "xitonix/trubka" ];

    brews = [
      "trubka" # Kafka CLI client
    ];

    casks = [
      "cloudflare-warp" # VPN client
      "mongodb-compass" # UI for MongoDB
      "cursor"
    ];
  };
}

