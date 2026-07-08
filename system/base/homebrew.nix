{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    homebrew = {
      enable = true;

      global.autoUpdate = false;
      onActivation.autoUpdate = false;
      onActivation.upgrade = false;
      onActivation.extraFlags = [ "--force" ];

      taps = [
        "pakerwreah/calendr"
      ];

      casks =
        let
          devTools = [
            "jetbrains-toolbox"
            "kitlangton-hex"
            "orbstack"
            "visual-studio-code"
          ];

          windowManagement = [
            "alt-tab"
            "rectangle"
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
            "logi-options+"
            "menubarx"
            "stats"
          ];

        in
        devTools ++ windowManagement ++ productivity ++ misc;
    };
  };
}
