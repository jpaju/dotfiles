{ ... }: {
  xdg.configFile = {
    "karabiner/karabiner.json".source = ./karabiner.json;
    "karabiner/assets".source = ./assets;
    "karabiner/automatic_backups".source = ./automatic_backups;
  };
}
