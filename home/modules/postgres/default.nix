{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.postgres.enable {
    home.packages = with pkgs; [
      pgcli
      pgformatter

      # SQL TUIs
      # lazysql
      # rainfrog
    ];
  };
}
