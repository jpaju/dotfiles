{ systemStateVersion, ... }:
{
  system.stateVersion = systemStateVersion;

  imports = [
    ./homebrew.nix
    ./nix-homebrew.nix
    ./markdown.nix
    ./macos-settings.nix
    ./nix-settings.nix
    ./overlays.nix
    ./users.nix
  ];
}
