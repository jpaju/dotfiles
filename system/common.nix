{ username, userhome, ... }: {

  users.users.${username}.home = userhome;

  imports = [ ./modules/darwin.nix ./modules/macos-settings.nix ./modules/nix-settings.nix ];

  homebrew = {
    enable = true;

    # When invoking homebrew manually, dont't auto update
    global.autoUpdate = false;

    # When invoking homebrew with nix-darwin, perform update&upgrade packages and clean up
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    caskArgs.no_quarantine = true;

    casks = let
      terminal = [ "ghostty" "wezterm" ];
      devTools = [
        # Newline please
        "dash"
        "docker"
        "jetbrains-toolbox"
        "postman"
        "visual-studio-code"
      ];

      windowManagement = [ "alt-tab" "betterdisplay" "monitorcontrol" "rectangle" ];

      productivity = [
        # Newline
        "arc"
        "firefox"
        "google-chrome"
        "karabiner-elements"
        "notion"
        "numi"
        "spotify"
        "ticktick"
        "raycast"
      ];

      misc = [
        # Please keep the newline :D
        "1password"
        "aldente"
        "appcleaner"
        "bartender"
        "logi-options+"
        "menubarx"
        "stats"
      ];

    in devTools ++ terminal ++ windowManagement ++ productivity ++ misc;
  };

}
