{ ... }: {

  homebrew = {
    enable = true;

    # onActivation.cleanup = "zap"; # TODO Uncomment to remove homebrew packages not listed below
    onActivation.autoUpdate = true;

    taps = [ "dashlane/tap" "pbkit/homebrew-tap" "smartthingscommunity/smartthings" ];
    brews = [ "dashlane-cli" "clang-format" "smartthings" "pbkit" ];

    caskArgs.no_quarantine = true;
    casks = let
      devTools = [ "dash" "docker" "jetbrains-toolbox" "postman" "visual-studio-code" ];
      terminal = [ "iterm2" ];
      windowManagement = [ "alt-tab" "betterdisplay" "monitorcontrol" "rectangle" ];
      productivity = [ "arc" "firefox" "google-chrome" "karabiner-elements" "notion" "numi" "signal" "spotify" ];
      misc = [ "aldente" "appcleaner" "bartender" "logi-options-plus" "menubarx" "stats" ];
    in devTools ++ terminal ++ windowManagement ++ productivity ++ misc;
  };

}

