{ pkgs, ... }:
{
  home.packages = with pkgs; [
    glow
    graph-easy
    slides
  ];

  xdg.configFile."glow/glow.yml".source = ./glow.yml;
}
