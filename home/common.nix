{ ... }: {

  home.stateVersion = "23.11";

  imports = [
    ./modules/cli-tools
    ./modules/dev-tools
    ./modules/fish
    ./modules/flakes
    ./modules/iterm2
    ./modules/karabiner
    ./modules/kitty
    ./modules/nix
    ./modules/secrets
    ./modules/starship
    ./modules/wezterm
    ./modules/zellij
  ];
}

