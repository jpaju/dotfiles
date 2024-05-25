{ pkgs, ... }: {

  home.packages = with pkgs; [ nh nom nvd ];

  programs.fish.shellAbbrs = {
    nxsh = "nix shell nixpkgs#";

    nxfu = "nix flake update";
    ndu = "nix flake update --flake ~/dotfiles";

    nxd = "nix develop";
    nxdbn = "nix develop path:$HOME/flakes/bun";
    nxdsc = "nix develop github:devinsideyou/scala-seed#java17";
    nxdts = "nix develop path:$HOME/flakes/typescript";
    nxdpy = "nix develop path:$HOME/flakes/python";
    nxdrs = "nix develop path:$HOME/flakes/rust";

    nds = "darwin_rebuild"; # NDS aka nix darwin switch
  };

  xdg.configFile."fish/functions/darwin_rebuild.fish".source = ./darwin_rebuild.fish;
}
