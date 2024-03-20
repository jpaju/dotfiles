{ ... }: {

  home.stateVersion = "23.11";

  imports = [
    ./modules/cli-tools
    ./modules/dev-tools
    ./modules/fish
    ./modules/flakes
    ./modules/git
    ./modules/helix
    ./modules/intellij
    ./modules/karabiner
    ./modules/kitty
    ./modules/iterm2
    ./modules/lazygit
    ./modules/secrets
    ./modules/starship
    ./modules/wezterm
  ];
}

