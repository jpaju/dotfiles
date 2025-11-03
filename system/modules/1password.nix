{
  config,
  lib,
  username,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles._1password.enable {
    homebrew.casks = [ "1password" ];
    home-manager.users.${username}.home.packages = [ pkgs._1password-cli ];
  };
}
