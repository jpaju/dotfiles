{ pkgs, fishUtils, ... }: {
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
  };

  # Required by done plugin to show icons in notifications
  home.packages = [ pkgs.terminal-notifier ];

  xdg.configFile = {
    "fish/conf.d" = {
      source = ./conf.d;
      recursive = true;
    };

    "fish/functions" = {
      source = ./functions;
      recursive = true;
    };

    "fish/completions" = {
      source = ./completions;
      recursive = true;
    };
  };
}

