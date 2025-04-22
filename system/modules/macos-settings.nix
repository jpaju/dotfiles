{ ... }: {
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  system.defaults = {
    spaces.spans-displays = false; # Displays have separate Spaces

    dock = {
      mru-spaces = false; # Auto-arrange spaces based on most recent use

      appswitcher-all-displays = true;

      show-process-indicators = true;
      show-recents = false;
      autohide = true;
      magnification = true;
      largesize = 70;
      tilesize = 50;
    };

    WindowManager.GloballyEnabled = false; # Disable Stage Manager

    # Menubar clock format: e.g 'd EEE h.mm.ss'
    menuExtraClock = {
      IsAnalog = false;
      ShowAMPM = true;
      ShowDate = 0;
      ShowDayOfWeek = false;
      ShowSeconds = true;
    };

    # Finder & files
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    finder = {
      AppleShowAllFiles = true; # Show hidden files
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
      Clicking = false; # Disable tap to click
      ActuationStrength = 1; # Disable silent clicking
      FirstClickThreshold = 1; # Normal click (0,1,2)
      SecondClickThreshold = 2; # Force click (0,1,2)
      TrackpadRightClick = true; # Right click with two-finger click
    };
  };
}
