{ pkgs, pkgs-master, system, helix-master, scls-main, ... }: {

  imports = [
    ./modules/dev-tools
    ./modules/fish
    ./modules/flakes
    ./modules/git
    ./modules/helix
    ./modules/intellij
    ./modules/karabiner
    ./modules/iterm2
    ./modules/lazygit
    ./modules/starship
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ripgrep.enable = true;

    yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      # Terminal
      nix-your-shell

      # CLI
      bat
      curlie
      eza
      fd
      fx
      fzf
      gping
      iperf3
      jq
      ncdu
      tldr
    ];
  };
}

