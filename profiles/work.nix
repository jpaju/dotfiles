{ username, pkgs, ... }:
{
  imports = [ ./common.nix ];

  home-manager.users.${username} = {
    imports = [ ../home/common.nix ];

    home.packages = with pkgs; [
      gnupg
      vault
    ];
  };

  dotfiles = {
    # Utilities
    work-vpn.enable = true;

    # Technologies
    aws.enable = true;
    k8s.enable = true;
    kafka.enable = true;
    mongodb.enable = true;
    postgres.enable = true;
    protobuf.enable = true;

    # Programming languages
    go.enable = true;
    kotlin.enable = true;
    python.enable = true;
    scala.enable = true;
    terraform.enable = true;
    typescript.enable = true;
  };
}
