{ pkgs, fishUtils, ... }:
{
  programs.fish = {
    plugins = [
      (fishUtils.fishPlugin pkgs "autopair")
      (fishUtils.fishPlugin pkgs "done")
      (fishUtils.fishGithubPlugin pkgs {
        name = "fish-abbreviation-tips";
        owner = "gazorby";
        rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
        sha256 = "F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
      })
    ];

    interactiveShellInit = ''
      # Done plugin options
      set __done_min_cmd_duration 5000 # Notify if command takes more than 5 seconds
      set __done_notify_sound 1        # Play sound with the notification
    '';
  };

  home.packages = pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.terminal-notifier # Required by done plugin to show icons in macOS notifications
  ];
}
