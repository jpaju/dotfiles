{ ... }: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = "use flake";
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
    "fish/functions/gitignore-flake.fish".source = ./gitignore-flake.fish;
    "fish/completions/add-nix-direnv.fish".source = ./add-nix-direnv-completions.fish;
  };
}
