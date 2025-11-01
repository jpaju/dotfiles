{ pkgs, ... }:
{

  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    aws-iam-authenticator
    aws-vault
    awscli2
    gnupg
    vault
  ];
}
