{ pkgs, username, ... }: {

  nix = {
    package = pkgs.nix;

    nixPath = [ "nixpkgs=${pkgs.path}" ];

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
    };

    settings = {
      experimental-features = "nix-command flakes";
      substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      trusted-users = [ "root ${username}" ];
    };
  };

}
