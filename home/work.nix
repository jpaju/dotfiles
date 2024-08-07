{ pkgs, ... }: {

  imports = [ ./common.nix ./modules/k9s ];

  # TODO Enable gpg agent
  home.packages = with pkgs; [
    aws-iam-authenticator
    aws-vault
    awscli2
    evans # gRPC TUI
    gnupg
    grpcurl # gRPC CLI
    kubectl
    kubectx
    pyenv
    vault
  ];

}

