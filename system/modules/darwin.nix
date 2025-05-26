{ pkgs, system, ... }: {

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nixpkgs.hostPlatform = system;

  fonts.packages = [ pkgs.nerd-fonts.fira-code ];

  environment = with pkgs; {
    shells = [ fish zsh ];
    systemPackages = [ ];
  };

}
