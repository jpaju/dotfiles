{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.dotfiles.rust.enable {
    home.packages = with pkgs; [
      rust-analyzer
      rustfmt
    ];

    xdg.configFile."flakes/rust/flake.nix".source = ./flake.nix;
  };
}
