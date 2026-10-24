{
  inputs,
  system,
  ...
}:
{
  home.packages = [ inputs.mitos.packages.${system}.default ];

  xdg.configFile = {
    "mitos/config.toml".source = ./config.toml;
    "mitos/languages.toml".source = ../helix/languages.toml;
    "mitos/ignore".source = ../helix/ignore;
  };
}
