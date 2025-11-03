{ pkgs, ... }:
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./broot.nix
    ./btop.nix
    ./catppuccin.nix
    ./direnv
    ./eza.nix
    ./fish
    ./fzf.nix
    ./git
    ./helix
    ./jq
    ./moor.nix
    ./nix
    ./starship
    ./yazi
    ./zellij
  ];

  programs.ripgrep.enable = true;
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    curlie
    entr # Watch mode for any CLI command
    fx # JSON TUI
    gum # CLI/TUI component library
    ncdu
    procps # On macOS includes only 'watch' command
    sshs # SSH TUI
    tokei # Count lines of code
    tlrc # Rust TLDR client
  ];
}
