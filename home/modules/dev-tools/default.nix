{ pkgs, ... }:
{

  imports = [
    ./docker
    ./flakes
    ./gh
    ./git
    ./helix
    ./terraform.nix
  ];

  home.packages = with pkgs; [
    pgcli
    tokei
  ];
}
