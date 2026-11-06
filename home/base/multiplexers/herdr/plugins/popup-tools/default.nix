{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."herdr/local-plugins/popup-tools" = {
    source = ./plugin;
    onChange =
      let
        herdrCLI = lib.getExe pkgs.herdr;
        pluginPath = "${config.xdg.configHome}/herdr/local-plugins/popup-tools";
      in
      "${herdrCLI} plugin link ${pluginPath}";
  };
}
