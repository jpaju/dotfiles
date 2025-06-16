{ ... }: {
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };

  # Bind Ctrl+R to open atuin
  programs.fish.interactiveShellInit = ''
    bind \cr _atuin_search
  '';
}
