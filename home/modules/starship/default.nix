{ pkgs-master, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs-master.starship;
  };

  xdg.configFile = {
    "starship.toml".source = ./starship.toml;
    "fish/conf.d/starship_async_transient_prompt.fish".source = ./starship_async_transient_prompt.fish;
  };
}
