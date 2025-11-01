{ username, ... }:
{
  imports = [
    ./common.nix
    ../system/work.nix
  ];

  home-manager.users.${username}.imports = [ ../home/work.nix ];

  dotfiles = {
    k8s.enable = true;
    kafka.enable = true;
    python.enable = true;
    scala.enable = true;
    typescript.enable = true;
  };
}
