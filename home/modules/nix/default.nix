{ pkgs, ... }: {

  home.packages = with pkgs; [ nh nom nvd ];

  programs.fish.shellAbbrs = {
    nxsh = "nix shell nixpkgs#";
    nxfu = "nix flake update";
    nxd = "nix develop";
    nds = "nix_darwin_switch";
  };

  xdg.configFile."fish/functions/nix_darwin_switch.fish".source = ./nix_darwin_switch.fish;
}
