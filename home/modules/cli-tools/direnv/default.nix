{ ... }: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fish.shellAbbrs = {
      de = "direnv";
      dea = "direnv allow";
      deb = "direnv block";
      des = "direnv status";
    };
  };

  xdg.configFile = {
    "fish/functions/add-nix-direnv.fish".source = ./add-nix-direnv.fish;
    "fish/completions/add-nix-direnv.fish".source = ./add-nix-direnv-completions.fish;
  };
}
