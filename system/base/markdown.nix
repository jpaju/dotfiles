{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    homebrew.brews = [
      "leaf-md"
    ];
  };
}
