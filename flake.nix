{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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

    helix.url = "github:gj1118/helix/master";
    llm-agents.url = "github:numtide/llm-agents.nix";
    catppuccin.url = "github:catppuccin/nix";
    gws.url = "github:googleworkspace/cli";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      helix,
      sops-nix,
      catppuccin,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "jaakkopaju";
      userhome = "/Users/${username}";

      # DO NOT CHANGE THESE
      systemStateVersion = 4;
      homeStateVersion = "23.11";

      llm-agents = inputs.llm-agents.packages.${system};
      gws = inputs.gws.packages.${system}.default;
      fishUtils = import "${self}/util/fish.nix";

      specialArgs = {
        inherit
          system
          homeStateVersion
          systemStateVersion
          username
          userhome
          nix-darwin
          home-manager
          sops-nix
          helix
          catppuccin
          llm-agents
          gws
          fishUtils
          ;
      };
    in
    {

      darwinConfigurations = {
        "Jaakkos-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          inherit specialArgs;

          modules = [ ./profiles/personal.nix ];
        };

        "Wolt-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          inherit specialArgs;

          modules = [ ./profiles/work.nix ];
        };
      };

      systemModules.nix-settings = import ./system/base/nix-settings.nix;

      exports = {
        options = import ./options.nix;
        home = import ./home;
        system = import ./system;
        util = import ./util;
      };
    };
}
