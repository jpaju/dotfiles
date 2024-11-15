{ pkgs, system, ... }: {

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  services = { nix-daemon.enable = true; };

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };

  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  environment = with pkgs; {
    shells = [ fish zsh ];
    systemPackages = [ ];
  };

  # Configure shells that loads the nix-darwin environment.
  programs = {
    zsh.enable = true;
    fish.enable = true;
  };
}
