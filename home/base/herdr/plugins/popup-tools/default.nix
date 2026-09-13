{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."herdr/local-plugins/popup-tools/herdr-plugin.toml" = {
    source = ./herdr-plugin.toml;
    onChange =
      let
        herdrCLI = lib.getExe pkgs.herdr;
        pluginPath = "${config.xdg.configHome}/herdr/local-plugins/popup-tools";
      in
      "${herdrCLI} plugin link ${pluginPath}";
  };
}
