{ config, lib, username, ... }:
{
  config = lib.mkIf config.dotfiles.terminal.enable {
    homebrew.casks = [
      "ghostty"
      "wezterm"
    ];

    home-manager.users.${username} = {
      imports = [
        ./ghostty
        ./wezterm
      ];
    };
  };
}
