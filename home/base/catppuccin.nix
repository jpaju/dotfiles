{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin.enable = true;
  catppuccin.autoEnable = false;
  catppuccin.flavor = "macchiato";
}
