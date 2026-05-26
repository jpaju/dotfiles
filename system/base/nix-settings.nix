{
  pkgs,
  lib,
  system,
  username,
  inputs,
  ...
}:
let
  isDarwin = lib.hasSuffix "darwin" system; # Cannot use stdenv.isDarwin because of infinite recursion

  commonSettings = {
    accept-flake-config = true;

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];

    trusted-users = [
      "root"
      username
    ];
  };

  sharedConfig = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = system;

    fonts.packages = [ pkgs.nerd-fonts.fira-code ];

    environment.shells = with pkgs; [
      fish
      zsh
    ];

    # Don't remove: required so the nix environment loads correctly when shells are installed by other means
    programs.zsh.enable = true;
    programs.fish.enable = true;
  };

  # The same settings live under different option paths per platform,
  # so we define them once as data above and route them into the right option here.
  darwinConfig = {
    determinateNix = {
      enable = true;
      customSettings = commonSettings;
    };
  };

  nixosConfig = {
    nix.settings = commonSettings // {
      experimental-features = "nix-command flakes";
    };
  };
in
{
  imports = lib.optionals isDarwin [ inputs.determinate.darwinModules.default ];

  config = lib.mkMerge [
    sharedConfig
    (lib.optionalAttrs isDarwin darwinConfig)
    (lib.optionalAttrs (!isDarwin) nixosConfig)
  ];
}
