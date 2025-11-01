{ pkgs, ... }:
{

  imports = [
    ./docker
    ./flakes
    ./gh
    ./git
    ./helix
  ];

  home.packages = with pkgs; [
    tokei
  ];
}
