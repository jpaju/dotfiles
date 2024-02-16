{ self, pkgs, system, username, ... }: {
  users.users.jaakkopaju.home = "/Users/${username}";

  nix = {
    package = pkgs.nix;

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
    };

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "root ${username}" ];
    };
  };

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };

  # Configure shells that loads the nix-darwin environment.
  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  environment = with pkgs; {
    shells = [ fish zsh ];
    loginShell = fish;
    systemPackages = [ cowsay ]; # TODO Remove this
  };

  homebrew = {
    enable = true;
    # onActivation.cleanup = "zap"; # TODO Uncomment to remove homebrew packages not listed below
    onActivation.autoUpdate = true;
    caskArgs.no_quarantine = true;

    taps = [ "dashlane/tap" "pbkit/homebrew-tap" ];
    brews = [ "dashlane-cli" "clang-format" "pbkit" ];

    casks = let
      devTools = [ "dash" "docker" "jetbrains-toolbox" "postman" "visual-studio-code" ];
      terminal = [ "font-fira-code-nerd-font" "iterm2" ]; # TODO Handle fonts with nix-darwin
      windowManagement = [ "alt-tab" "monitorcontrol" "rectangle" ];
      productivity = [ "arc" "firefox" "google-chrome" "karabiner-elements" "notion" "numi" "signal" "spotify" ];
      misc = [ "aldente" "appcleaner" "bartender" "menubarx" "stats" ];
    in devTools ++ terminal ++ windowManagement ++ productivity ++ misc;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  services.nix-daemon.enable = true;
}
