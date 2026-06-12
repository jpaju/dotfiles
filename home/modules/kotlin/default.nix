{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.kotlin.enable {
    home.file."flakes/kotlin/flake.nix".source = ./flake.nix;
  };
}
