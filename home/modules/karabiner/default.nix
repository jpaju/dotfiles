{ ... }: {
  xdg.configFile = {
    "karabiner/karabiner.json".source = ./karabiner.json;
    "karabiner/assets".source = ./assets;
    "karabiner/automatic_backup".source = ./automatic_backup;
  };
}
