{ pkgs, ... }:
{

  imports = [
    ./docker
    ./gh
    ./git
    ./helix
  ];

  home.packages = with pkgs; [
    tokei
  ];
}
