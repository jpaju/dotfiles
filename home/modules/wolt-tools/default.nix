{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.wolt-tools.enable {
    home.packages = with pkgs; [
      gnupg
      vault
    ];
  };
}
