{ pkgs, ... }: {

  imports = [
    # Comment just to keep newlines when formatted :D
    ./atuin
    ./bat
    ./direnv
    ./eza
    ./fzf
    ./jq
  ];

  programs = {
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

