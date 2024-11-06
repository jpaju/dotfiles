{ pkgs, ... }: {

  home.stateVersion = "23.11";

  home.packages = [ pkgs._1password ];

  imports = [
    ./modules/cli-tools
    ./modules/dev-tools
    ./modules/fish
    ./modules/flakes
    ./modules/karabiner
    ./modules/nix
    ./modules/secrets
    ./modules/starship
    ./modules/wezterm
    ./modules/zellij
  ];
}

