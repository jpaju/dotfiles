{ pkgs, ... }:
{
  home.packages = [ pkgs.moar ];
  home.sessionVariables = {
    PAGER = "moar";
    MOAR = "--no-linenumbers --style=catppuccin-macchiato";
  };
}
