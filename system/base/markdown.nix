{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    homebrew.brews = [
      "leaf-md"
    ];
  };
}
