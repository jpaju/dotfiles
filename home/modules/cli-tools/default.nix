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
    fx # JSON TUI
    gobang # SQL TUI
    gping
    gum # CLI/TUI component library
    iperf3
    moar # Pager
    ncdu
    nix-your-shell # Nix shell support for fish
    tlrc # Rust TLDR client
  ];
}

