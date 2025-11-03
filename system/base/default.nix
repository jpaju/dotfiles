{ systemStateVersion, ... }:
{
  system.stateVersion = systemStateVersion;

  imports = [
    ./homebrew.nix
    ./macos-settings.nix
    ./nix-settings.nix
    ./users.nix
  ];
}
