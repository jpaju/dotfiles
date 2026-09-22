{
  config,
  lib,
  pkgs,
  ...
}:
let
  aioesphomeapi-discover-once = pkgs.writeShellScriptBin "aioesphomeapi-discover-once" (
    builtins.readFile ./agent-tools/aioesphomeapi-discover-once.sh
  );
in
{
  config = lib.mkIf config.dotfiles.home-automation.enable {
    home.packages = [
      aioesphomeapi-discover-once
      pkgs.python3Packages.aioesphomeapi
    ];
  };
}
