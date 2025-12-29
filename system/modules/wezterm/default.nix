{
  lib,
  config,
  username,
  ...
}:
{
  config = lib.mkIf config.dotfiles.terminal.enable {
    homebrew.casks = [ "wezterm" ];
    home-manager.users.${username} = {
      xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
    };
  };
}
