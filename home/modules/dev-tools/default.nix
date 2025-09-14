{ pkgs, ... }:
{

  imports = [
    ./docker
    ./flakes
    ./gh
    ./git
    ./helix
    ./intellij.nix
    ./terraform.nix
  ];

  home.packages = with pkgs; [
    coursier
    kcat
    pgcli
    tokei
  ];

  home.file.".sbt/1.0/global.sbt".source = ./global.sbt;
}
