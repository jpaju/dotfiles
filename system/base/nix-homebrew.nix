{
  inputs,
  pkgs,
  lib,
  system,
  username,
  ...
}:
let
  isDarwin = lib.hasSuffix "darwin" system;
in
{
  imports = lib.optionals isDarwin [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  config = lib.mkIf pkgs.stdenv.isDarwin {
    nix-homebrew = {
      enable = true;
      enableRosetta = false;
      user = username;

      # Adopt the existing manually-installed Homebrew in place on first switch, preserving already-installed packages
      autoMigrate = true;

      # Enables adding taps outside from Nix
      mutableTaps = true;
    };
  };
}
