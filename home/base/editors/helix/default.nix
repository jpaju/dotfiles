{
  system,
  inputs,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${system}.default;
  };

  xdg.configFile = {
    "helix/config.toml".source = ./config.toml;
    "helix/languages.toml".source = ./languages.toml;
    "helix/ignore".source = ../ignore;
    "helix/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}
