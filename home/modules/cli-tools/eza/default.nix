{ ... }: {

  programs = {
    eza = {
      enable = true;
      enableFishIntegration = false; # Enabling this overrides aliases such as 'll' and 'la'
      icons = true;
      git = true;
    };

    fish.shellAliases = {
      ll = "eza --long --group --icons --header --classify --git";
      ls = "eza --icons --header --classify";
      la = "ll --all";
    };
  };
}

