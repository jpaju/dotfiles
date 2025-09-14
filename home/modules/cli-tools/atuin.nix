{ ... }:
{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };

  catppuccin.atuin.enable = true;

  # Bind Ctrl+R to open atuin
  programs.fish.interactiveShellInit = ''
    bind \cr _atuin_search
  '';
}
