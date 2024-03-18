{ ... }: {
  xdg.configFile = {
    "kitty/kitty.conf".source = ./kitty.conf;

    "kitty/themes" = {
      source = ./themes;
      recursive = true;
    };
  };
}
