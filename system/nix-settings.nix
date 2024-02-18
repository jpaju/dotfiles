{ pkgs, username, ... }: {

  nix = {
    package = pkgs.nix;

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
    };

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "root ${username}" ];
    };
  };

}
