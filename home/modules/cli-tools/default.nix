{ pkgs, ... }: {

  imports = [
    # Comment just to keep newlines when formatted :D
    ./atuin
    ./broot
    ./bat
    ./direnv
    ./eza
    ./fzf
    ./jq
    ./yazi
  ];

  programs = {
    ripgrep.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home.packages = with pkgs; [

    curlie
    fx
    gobang
    gping
    gum
    iperf3
    moar
    ncdu
    nix-your-shell
    tlrc

  ];
}

