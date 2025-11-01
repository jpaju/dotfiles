{ ... }:
{
  homebrew = {
    enable = true;

    # When invoking homebrew manually, dont't auto update
    global.autoUpdate = false;

    # When invoking homebrew with nix-darwin, perform update&upgrade packages and clean up
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    caskArgs.no_quarantine = true;

    taps = [ "pakerwreah/calendr" ];

    casks =
      let
        terminal = [
          "ghostty"
          "wezterm"
        ];
        devTools = [
          "dash"
          "cursor"
          "orbstack"
          "jetbrains-toolbox"
          "postman"
          "visual-studio-code"
        ];

        windowManagement = [
          "alt-tab"
          "betterdisplay"
          "monitorcontrol"
          "rectangle"
        ];

        productivity = [
          "arc"
          "calendr"
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
          "1password"
          "aldente"
          "appcleaner"
          "bartender"
          "logi-options+"
          "menubarx"
          "stats"
        ];

      in
      devTools ++ terminal ++ windowManagement ++ productivity ++ misc;
  };
}
