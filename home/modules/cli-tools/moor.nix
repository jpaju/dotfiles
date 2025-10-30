{ pkgs, ... }:
{
  home.packages = [ pkgs.moor ];
  home.sessionVariables = {
    PAGER = "moor";
    MOOR = "--no-linenumbers --style=catppuccin-macchiato";
  };
}
