{ pkgs, ... }:
{
  home.packages = [ pkgs.tuicr ];

  xdg.configFile."tuicr/config.toml".source = ./config.toml;
}
