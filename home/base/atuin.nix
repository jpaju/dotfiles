{ ... }:
{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };

  catppuccin.atuin.enable = true;
}
