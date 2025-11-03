{ pkgs, ... }:
{

  home.packages = with pkgs; [
    nh
    nix-output-monitor
    nvd
  ];

  programs.fish.shellAbbrs = {
    nxsh = "nix shell nixpkgs#";
    nxfu = "nix flake update";
    nxd = "nix develop";
    nrs = "nix_rebuild_switch &| nom";
  };

  xdg.configFile."fish/functions/nix_rebuild_switch.fish".source = ./nix_rebuild_switch.fish;
}
