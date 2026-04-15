{ ... }:
{
  xdg.configFile."lumen/lumen.config.json".text = builtins.toJSON {
    theme = "catppuccin-mocha";
  };
}
