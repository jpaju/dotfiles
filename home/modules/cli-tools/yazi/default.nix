{ ... }: {
  programs.yazi = {
    enable = true;

    settings = {
      manager = {
        ratio = [ 1 2 3 ];
        show_hidden = true;
        show_symlink = true;
      };
    };

    initLua = ./init.lua;

    keymap = {
      input.prepend_keymap = [{
        run = "close";
        on = [ "<Esc>" ];
        desc = "Cancel input";
      }];
    };
  };

  xdg = {
    # See: https://github.com/catppuccin/yazi
    configFile."yazi/theme.toml".source = ./themes/catppuccin-macchiato.toml;
    configFile."yazi/Catppuccin-macchiato.tmTheme".source = ./themes/Catppuccin-macchiato.tmTheme;
  };
}
