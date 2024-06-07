{ ... }: {
  programs = {
    yazi = {
      enable = true;
      enableFishIntegration = true;
      settings = { manager.ratio = [ 1 2 3 ]; };
    };
  };

  xdg = {
    # See: https://github.com/catppuccin/yazi
    configFile."yazi/theme.toml".source = ./themes/catppuccin-macchiato.toml;
    configFile."yazi/Catppuccin-macchiato.tmTheme".source = ./themes/Catppuccin-macchiato.tmTheme;
  };
}
