{ ... }: {

  homebrew = {
    enable = true;
    # onActivation.cleanup = "zap"; # TODO Uncomment to remove homebrew packages not listed below
    # onActivation.autoUpdate = true; # TODO Uncomment when configuration ready
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

