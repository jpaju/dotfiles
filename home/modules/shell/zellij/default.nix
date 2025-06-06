{ ... }: {
  programs = {
    zellij = { enable = true; };

    fish.shellAbbrs = {
      za = "zellij attach";
      zac = "zellij attach (basename (pwd)) --create";
      zls = "zellij list-sessions";
      zkl = "zellij kill-session";
    };
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}

