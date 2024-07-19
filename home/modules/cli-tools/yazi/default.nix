{ ... }: {
  programs = {
    yazi = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        manager = {
          ratio = [ 1 2 3 ];
          show_hidden = true;
          show_symlink = true;
        };
      };

      initLua = ./init.lua;

      keymap = {
        manager.prepend_keymap = [{
          run = "plugin --sync smart-paste";
          on = [ "p" ];
          desc = "Paste into the hovered directory or CWD";
        }];

        input.prepend_keymap = [{
          run = "close";
          on = [ "<Esc>" ];
          desc = "Cancel input";
        }];
      };

      plugins = { smart-paste = ./plugins/smart-paste.yazi; };

    };
  };

  xdg = {
    # See: https://github.com/catppuccin/yazi
    configFile."yazi/theme.toml".source = ./themes/catppuccin-macchiato.toml;
    configFile."yazi/Catppuccin-macchiato.tmTheme".source = ./themes/Catppuccin-macchiato.tmTheme;
  };
}
