{ pkgs, username, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.enable = true;
  nix.package = pkgs.nix;
  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    trusted-users = [
      "root"
      username
    ];
  };

  # Don't remove if shells are installed by other means, otherwise nix environment is not loaded correctly
  programs.zsh.enable = true;
  programs.fish.enable = true;

  nix.gc =
    let
      nixOsSchedule = {
        dates = "weekly";
      };
      darwinSchedule = {
        interval.Weekday = 0;
        interval.Hour = 0;
        interval.Minute = 0;
      };
      gcSchedule = if pkgs.stdenv.isDarwin then darwinSchedule else nixOsSchedule;
    in
    {
      automatic = true;
      options = "--delete-older-than 30d";
    }
    // gcSchedule;
}
