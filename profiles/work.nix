{ username, ... }:
{
  imports = [
    ./common.nix
    ../system/work.nix
  ];

  home-manager.users.${username}.imports = [ ../home/work.nix ];

  dotfiles = {
    go.enable = true;
    k8s.enable = true;
    kafka.enable = true;
    protobuf.enable = true;
    python.enable = true;
    scala.enable = true;
    terraform.enable = true;
    typescript.enable = true;
  };
}
