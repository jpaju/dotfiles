{ pkgs, localPkgs, ... }:
{
  home.packages = with pkgs; [
    glow
    graph-easy
    slides
    localPkgs.leaf
  ];

  xdg.configFile."glow/glow.yml".source = ./glow.yml;
  xdg.configFile."leaf/config.toml".source = ./leaf.toml;
}
