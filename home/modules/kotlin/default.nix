{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.kotlin.enable {
    home.packages = with pkgs; [
      kotlin-language-server
    ];

    home.file."flakes/kotlin/flake.nix".source = ./flake.nix;
  };
}
