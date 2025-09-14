{ username, userhome, ... }:
{

  users.users.${username}.home = userhome;

  /*
    Apparently temporary fix when nix-darwin is doing some migrations
    For more information, see:
      - https://github.com/nix-darwin/nix-darwin/pull/1017
      - https://github.com/nix-darwin/nix-darwin/pull/1341
      - https://github.com/nix-darwin/nix-darwin/issues/96
  */
  system.primaryUser = username;

  imports = [
    ./modules/darwin.nix
    ./modules/macos-settings.nix
    ./modules/nix-settings.nix
  ];

  homebrew = {
    enable = true;

    # When invoking homebrew manually, dont't auto update
    global.autoUpdate = false;

    # When invoking homebrew with nix-darwin, perform update&upgrade packages and clean up
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    caskArgs.no_quarantine = true;

    brews = [ "JetBrains/utils/kotlin-lsp" ];

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
