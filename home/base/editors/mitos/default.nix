{
  inputs,
  system,
  ...
}:
{
  home.packages = [ inputs.mitos.packages.${system}.default ];

  xdg.configFile = {
    "mitos/config.toml".source = ./config.toml;
    "mitos/languages.toml".source = ./languages.toml;
    "mitos/ignore".source = ../ignore;
    "mitos/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}
