{ pkgs, ... }:
{
  home.packages = with pkgs; [
    glow
    graph-easy
    slides
    leaf-markdown-viewer
  ];

  xdg.configFile."glow/glow.yml".source = ./glow.yml;
  xdg.configFile."leaf/config.toml".source = ./leaf.toml;
}
