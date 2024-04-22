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
    gping
    gum
    iperf3
    ncdu
    nix-your-shell
    tlrc

  ];
}

