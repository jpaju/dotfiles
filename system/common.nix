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

    taps = [ "dashlane/tap" "pbkit/homebrew-tap" ];
    brews = [ "dashlane-cli" "pbkit" ];

    casks = let
      devTools = [ "dash" "docker" "jetbrains-toolbox" "postman" "visual-studio-code" ];
      terminal = [ "iterm2" "kitty" "wezterm" ];
      windowManagement = [ "alt-tab" "betterdisplay" "monitorcontrol" "rectangle" ];
      productivity = [ "arc" "firefox" "google-chrome" "karabiner-elements" "notion" "numi" "spotify" ];
      misc = [ "aldente" "appcleaner" "bartender" "logi-options-plus" "menubarx" "stats" ];
    in devTools ++ terminal ++ windowManagement ++ productivity ++ misc;
  };

}
