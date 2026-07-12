{ pkgs, fishUtils, ... }:
{
  programs.fish.plugins = [
    (fishUtils.fishPlugin pkgs "autopair")
  ];
}
