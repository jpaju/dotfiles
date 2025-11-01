{ username, ... }:
{
  imports = [
    ./common.nix
    ../system/work.nix
  ];

  home-manager.users.${username}.imports = [ ../home/work.nix ];

  dotfiles = {
    kafka.enable = true;
  };
}
