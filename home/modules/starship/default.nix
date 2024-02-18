{ ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile = {
    "starship.toml".source = ./starship.toml;
    "fish/conf.d/starship_async_transient_prompt.fish".source = ./starship_async_transient_prompt.fish;
  };
}
