{ ... }: {

  home.stateVersion = "23.11";

  imports = [
    ./modules/cli-tools
    ./modules/dev-tools
    ./modules/fish
    ./modules/flakes
    ./modules/helix
    ./modules/karabiner
    ./modules/kitty
    ./modules/iterm2
    ./modules/secrets
    ./modules/starship
    ./modules/wezterm
  ];
}

