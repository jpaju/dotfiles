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

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
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

      fishUtils = import "${self}/util/fish.nix";

      specialArgs = {
        inherit system;
        inherit username;
        inherit userhome;
        inherit nix-darwin;
        inherit home-manager;
        inherit sops-nix;
        inherit helix;
        inherit catppuccin;
        inherit fishUtils;
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

      # Export certain modules to be reused from other flakes by importing
      systemModules.nix-settings = import ./system/modules/nix-settings.nix;

      homeModules = {
        inherit fishUtils;
        ai = import ./home/modules/ai;
        cli-tools = import ./home/modules/cli-tools;
        dev-tools = import ./home/modules/dev-tools;
        nix = import ./home/modules/nix;
        shell = import ./home/modules/shell;
      };
    };
}
