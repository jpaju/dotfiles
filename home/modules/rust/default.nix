{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.rust.enable {
    home.packages = with pkgs; [
      rust-analyzer
      rustfmt
    ];

    home.file."flakes/rust/flake.nix".source = ./flake.nix;
  };
}
