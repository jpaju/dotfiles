{ username, ... }:
{
  imports = [
    ./common.nix
    ../system/personal.nix
  ];

  home-manager.users.${username}.imports = [ ../home/personal.nix ];

  dotfiles = {
    kafka.enable = false;
    mqtt.enable = true;
    scala.enable = true;
    typescript.enable = true;
  };
}
