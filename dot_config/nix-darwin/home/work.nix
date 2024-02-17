{ pkgs, ... }: {

  imports = [ ./common.nix ];

  # TODO Enable gpg agent
  # TODO Add Hashicorp vault
  home = { packages = with pkgs; [ aws-vault gnupg pinentry ]; };
}

