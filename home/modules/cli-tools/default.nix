{ pkgs, ... }:
{

  imports = [
    ./atuin.nix
    ./broot.nix
    ./bat.nix
    ./btop.nix
    ./direnv
    ./eza.nix
    ./fzf.nix
    ./jq
    ./moor.nix
    ./yazi
  ];

  programs.ripgrep.enable = true;
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    curlie
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
}
