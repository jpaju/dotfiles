{
  config,
  lib,
  username,
  ...
}:
{
  config = lib.mkIf config.dotfiles.karabiner.enable {
    homebrew.casks = [ "karabiner-elements" ];

    home-manager.users.${username} = {
      xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
    };
  };
}
