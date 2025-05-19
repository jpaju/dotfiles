{ pkgs, config, fishUtils, ... }: {
  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;

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
      # Load function descriptions to show them in auto-completion
      # This is a workaround until the following issue is resolved: https://github.com/fish-shell/fish-shell/issues/328
      # Stole from this comment: https://github.com/fish-shell/fish-shell/issues/1915#issuecomment-72315918
      for i in (functions);functions $i > /dev/null;end

      bind \cf 'fg 1&> /dev/null'

      # Done plugin options
      set __done_min_cmd_duration 5000 # Notify if command takes more than 5 seconds
      set __done_notify_sound 1        # Play sound with the notification
    '';
  };

  # Nix shell support for fish (or any shell other than bash)
  programs.nix-your-shell.enable = true;

  home.packages = pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.terminal-notifier # Required by done plugin to show icons in macOS notifications
  ];

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";

    configFile = {
      "fish/conf.d" = {
        source = ./conf.d;
        recursive = true;
      };

      "fish/functions" = {
        source = ./functions;
        recursive = true;
      };
    };
  };
}

