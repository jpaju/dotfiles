{ pkgs, ... }:
let
  fishPlugin = name: {
    inherit name;
    src = pkgs.fishPlugins.${name}.src;
  };

  fishGithubPlugin = { name, owner, rev, sha256 }: {
    name = name;
    src = pkgs.fetchFromGitHub {
      inherit owner;
      repo = name;
      rev = rev;
      sha256 = sha256;
    };
  };
in {
  programs = {
    fish = {
      enable = true;

      plugins = [
        (fishPlugin "autopair")
        (fishPlugin "fzf-fish")
        (fishGithubPlugin {
          name = "fish-abbreviation-tips";
          owner = "gazorby";
          rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
          sha256 = "F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        })
      ];
    };
  };

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

