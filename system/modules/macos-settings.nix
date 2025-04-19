{ ... }: {
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

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

    finder = {
      AppleShowAllExtensions = true; # Show all file extensions
      FXPreferredViewStyle = "clmv"; # Finder preferred view is column
      ShowStatusBar = true;
      ShowPathbar = true;
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

    ".GlobalPreferences"."com.apple.mouse.scaling" = 0.875; # External mouse tracking speed (0.0 - 3.0)

    trackpad = {
      Clicking = false;
      FirstClickThreshold = 1; # Normal click (0,1,2)
      SecondClickThreshold = 2; # Force click (0,1,2)
      TrackpadRightClick = true; # Right click with two-finger click
    };
  };
}
