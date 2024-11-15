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

    taps = [ "pbkit/homebrew-tap" ];
    brews = [ ];

    casks = let
      devTools = [ "dash" "docker" "jetbrains-toolbox" "postman" "visual-studio-code" ];
      terminal = [ "wezterm" ];
      windowManagement = [ "alt-tab" "betterdisplay" "monitorcontrol" "rectangle" ];
      productivity = [ "arc" "firefox" "google-chrome" "karabiner-elements" "notion" "numi" "spotify" ];
      misc = [ "1password" "aldente" "appcleaner" "bartender" "logi-options+" "menubarx" "stats" ];
    in devTools ++ terminal ++ windowManagement ++ productivity ++ misc;
  };

}
