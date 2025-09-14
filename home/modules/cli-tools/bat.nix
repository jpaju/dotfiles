{ pkgs, ... }:
{
  programs.fish = {
    shellAliases.cat = "bat";
    interactiveShellInit = "batman --export-env | source";
  };

  programs.bat = {
    enable = true;
    extraPackages = [ pkgs.bat-extras.batman ];
  };

  catppuccin.bat.enable = true;
}
