{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
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
          devTools = [
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

          browsers = [
            "arc"
            "firefox"
            "google-chrome"
            "zen"
          ];

          productivity = [
            "calendr"
            "notion"
            "numi"
            "spotify"
            "ticktick"
            "raycast"
          ];

          misc = [
            "aldente"
            "appcleaner"
            "bartender"
            "logi-options+"
            "menubarx"
            "stats"
          ];

        in
        devTools ++ windowManagement ++ browsers ++ productivity ++ misc;
    };
  };
}
