{ pkgs-master, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs-master.starship;
  };

  xdg.configFile = { "starship.toml".source = ./starship.toml; };
}
