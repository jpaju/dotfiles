{ ... }: {
  programs = {
    atuin = {
      enable = true;
      enableFishIntegration = true;
      flags = [ "--disable-up-arrow" ];
    };

    fish = {
      # Bind Ctrl+R to open atuin
      interactiveShellInit = ''
        bind \cr _atuin_search
      '';
    };
  };
}
