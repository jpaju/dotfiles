{
  config,
  lib,
  localPkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.kotlin.enable {
    home.packages = [ localPkgs.kotlin-lsp ];

    home.file."flakes/kotlin/flake.nix".source = ./flake.nix;
  };
}
