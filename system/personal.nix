{ ... }:
{
  imports = [ ./common.nix ];

  homebrew.casks =
    let
      media = [
        "plex-media-server" # TODO Remove
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
