{ pkgs, ... }: {

  home.stateVersion = "23.11";

  home.packages = [ pkgs._1password-cli ];

  home.shell.enableFishIntegration = true;

  imports = [
    ./modules/cli-tools
    ./modules/dev-tools
    ./modules/fish
    ./modules/flakes
    ./modules/ghostty
    ./modules/karabiner
    ./modules/nix
    ./modules/secrets
    ./modules/starship
    ./modules/wezterm
    ./modules/zellij
  ];
}

