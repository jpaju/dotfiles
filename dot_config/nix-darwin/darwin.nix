{ pkgs, system, username, ... }: {

  users.users.jaakkopaju.home = "/Users/${username}";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  services = {
    nix-daemon.enable = true;
    # karabiner-elements.enable = true;
  };

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };

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

  # macOS system settings
  system.defaults = {
    spaces.spans-displays = true; # Displays have separate Spaces

    dock = {
      mru-spaces = false; # Auto-arrange spaces based on most recent use
      show-recents = false;
      autohide = true;
      magnification = true;
      largesize = 70;
      tilesize = 50;
    };

    # Menubar clock format: e.g 'd EEE h.mm.ss'
    menuExtraClock = {
      IsAnalog = false;
      ShowAMPM = true;
      ShowDate = 0;
      ShowDayOfWeek = false;
      ShowSeconds = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";

      ApplePressAndHoldEnabled = false; # Holding a key repeats it rather than showing the accent menu
      InitialKeyRepeat = 30;
      KeyRepeat = 2;

      "com.apple.trackpad.scaling" = 1.0; # Trackpad tracking speed (0.0 - 3.0)
      "com.apple.swipescrolldirection" = true; # Natural scrolling
      "com.apple.keyboard.fnState" = true; # Use function keys as standard function keys
    };

    trackpad = {
      Clicking = true;
      FirstClickThreshold = 1; # Normal click (0,1,2)
      SecondClickThreshold = 2; # Force click (0,1,2)
      TrackpadRightClick = true; # Right click with two-finger click
    };

  };

  environment = with pkgs; {
    shells = [ fish zsh ];
    loginShell = fish;
    systemPackages = [ cowsay ]; # TODO Remove this
  };

  # Configure shells that loads the nix-darwin environment.
  programs = {
    zsh.enable = true;
    fish.enable = true;
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

}
