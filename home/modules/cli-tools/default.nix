{ pkgs, ... }: {

  imports = [
    # Comment just to keep newlines when formatted :D
    ./atuin.nix
    ./broot.nix
    ./bat.nix
    ./direnv
    ./eza.nix
    ./fzf.nix
    ./jq
    ./moar.nix
    ./yazi
  ];

  programs = {
    ripgrep.enable = true;
    zoxide.enable = true;
  };

  home.packages = with pkgs; [
    curlie
    claude-code
    entr # Watch mode for any CLI command
    fx # JSON TUI
    gobang # SQL TUI
    gping
    gum # CLI/TUI component library
    iperf3
    ncdu
    procps # On macOS includes only 'watch' command
    sshs # SSH TUI
    tlrc # Rust TLDR client
  ];

  programs.fish.shellAbbrs.cc = "claude";
}

