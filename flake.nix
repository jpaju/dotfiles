{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    helix.url = "github:gj1118/helix/master";
    llm-agents.url = "github:numtide/llm-agents.nix";
    catppuccin.url = "github:catppuccin/nix";
    gws.url = "github:googleworkspace/cli";
  };

  outputs =
    inputs@{ self, ... }:
    let
      system = "aarch64-darwin";
      username = "jaakkopaju";
      userhome = "/Users/${username}";

      # DO NOT CHANGE THESE
      systemStateVersion = 4;
      homeStateVersion = "23.11";

      fishUtils = import "${self}/util/fish.nix";

      specialArgs = {
        inherit
          system
          inputs
          homeStateVersion
          systemStateVersion
          username
          userhome
          fishUtils
          ;
      };
    in
    {

      darwinConfigurations = {
        "Jaakkos-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          inherit specialArgs;

          modules = [ ./profiles/personal.nix ];
        };

        "Wolt-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          inherit specialArgs;

          modules = [ ./profiles/work.nix ];
        };
      };

      exports = {
        options = import ./options.nix;
        home = import ./home;
        nix-settings = import ./system/base/nix-settings.nix;
      };
    };
}
