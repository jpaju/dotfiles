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
    ./json
    ./markdown
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
    gum # CLI/TUI component library
    ncdu
    procps # On macOS includes only 'watch' command
    serpl # Global search and replace
    sshs # SSH TUI
    tlrc # Rust TLDR client
    tokei # Count lines of code
  ];

  programs.fish.shellAbbrs.loc = "tokei";
}
