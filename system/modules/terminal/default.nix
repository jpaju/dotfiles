{ config, lib, username, ... }:
{
  config = lib.mkIf config.dotfiles.terminal.enable {
    homebrew.casks = [
      "wezterm"
    ];

    home-manager.users.${username} = {
      imports = [
        ./wezterm
      ];
    };
  };
}
