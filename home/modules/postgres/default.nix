{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.postgres.enable {
    home.packages = with pkgs; [
      gobang # SQL TUI
      pgcli
      pgformatter
    ];
  };
}
