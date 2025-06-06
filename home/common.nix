{ pkgs, ... }: {

  home.stateVersion = "23.11";

  home.packages = [ pkgs._1password-cli ];

  imports = [
    ./modules/ai
    ./modules/cli-tools
    ./modules/dev-tools
    ./modules/karabiner
    ./modules/nix
    ./modules/secrets
    ./modules/shell
    ./modules/terminal
  ];
}

