{ ... }: {

  imports = [ ./common.nix ];

  homebrew = {
    taps = [ "smartthingscommunity/smartthings" ];
    brews = [ "smartthings" ];
    casks = [ "discord" "teamviewer" "signal" ];
  };

}

