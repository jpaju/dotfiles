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
    entr # Watch mode for any CLI command
    fx # JSON TUI
    gobang # SQL TUI
    gping
    gum # CLI/TUI component library
    iperf3
    moar # Pager
    ncdu
    procps # On macOS includes only 'watch' command
    nix-your-shell # Nix shell support for fish
    sshs # SSH TUI
    tlrc # Rust TLDR client
  ];
}

