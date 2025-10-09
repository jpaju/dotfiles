{ ... }:
{
  imports = [ ./common.nix ];

  homebrew.casks =
    let
      media = [
        "handbrake-app"
        "makemkv"
        "vlc"

      ];
      communication = [
        "discord"
        "signal"
      ];
      remoteAccess = [ "teamviewer" ];
    in
    media ++ communication ++ remoteAccess;
}
