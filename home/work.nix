{ pkgs, ... }: {

  imports = [ ./common.nix ./modules/k8s.nix ];

  home.packages = with pkgs; [
    aws-iam-authenticator
    aws-vault
    awscli2
    evans # gRPC TUI
    gnupg
    grpcurl # gRPC CLI
    pyenv
    vault
  ];
}

