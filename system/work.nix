{ ... }: {

  imports = [ ./common.nix ];

  homebrew = { casks = [ "cloudflare-warp" ]; };
}

