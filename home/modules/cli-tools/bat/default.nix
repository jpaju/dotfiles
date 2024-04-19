{ ... }: {
  programs = {
    bat = {
      enable = true;
      config = { theme = "TwoDark"; };
    };

    fish.shellAliases = { cat = "bat"; };
  };
}
