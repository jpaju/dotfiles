{ pkgs, ... }: {

  imports = [ ./common.nix ];

  # TODO Enable gpg agent
  home.packages = with pkgs; [

    aws-iam-authenticator
    aws-vault
    awscli2
    gnupg
    kubectl
    kubectx
    pyenv
    vault
  ];

}

