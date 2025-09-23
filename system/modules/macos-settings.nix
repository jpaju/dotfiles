{ ... }:
{
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";

    # Desktop & display
    spaces.spans-displays = false; # Displays have separate Spaces
    NSGlobalDomain.AppleSpacesSwitchOnActivate = true; # Switch to space with open windows
    dock.mru-spaces = false; # Auto-arrange spaces based on most recent use
    dock.appswitcher-all-displays = true;
    WindowManager.GloballyEnabled = false; # Disable Stage Manager

    dock = {
      show-process-indicators = true;
      show-recents = false;
      autohide = true;
      magnification = true;
      largesize = 70;
      tilesize = 50;
    };

    # Menubar items
    controlcenter = {
      AirDrop = false;
      BatteryShowPercentage = false;
      Bluetooth = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };

    # Menubar clock format: e.g 'd EEE h.mm.ss'
    menuExtraClock = {
      IsAnalog = false;
      ShowAMPM = false;
      Show24Hour = true;
      ShowSeconds = true;
      ShowDayOfWeek = false;
      ShowDate = 2; # 0 = When space allows 1 = Always 2 = Never
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

    # Keyboard
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false; # Holding a key repeats it rather than showing the accent menu
      InitialKeyRepeat = 30;
      KeyRepeat = 2;
      "com.apple.keyboard.fnState" = true; # Use function keys as standard function keys
    };

    # External mouse
    ".GlobalPreferences"."com.apple.mouse.scaling" = 0.875; # Tracking speed (0.0 - 3.0)

    # Trackpad
    NSGlobalDomain = {
      "com.apple.trackpad.scaling" = 1.0; # Tracking speed (0.0 - 3.0)
      "com.apple.swipescrolldirection" = true; # Natural scrolling
    };
    trackpad = {
      Clicking = false; # Disable tap to click
      ActuationStrength = 1; # Disable silent clicking
      FirstClickThreshold = 1; # Normal click (0,1,2)
      SecondClickThreshold = 2; # Force click (0,1,2)
      TrackpadRightClick = true; # Right click with two-finger click
    };
  };
}
