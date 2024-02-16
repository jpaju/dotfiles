{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-master = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scls-main = {
      url = "github:estin/simple-completion-language-server/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nix-darwin, nixpkgs, nixpkgs-master, home-manager, helix-master, scls-main, ... }:
    let
      system = "aarch64-darwin";
      hostname = "Jaakkos-MacBook-Pro"; # TODO Make this configurable depending on the machine
      username = "jaakkopaju";

      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-master = nixpkgs-master.legacyPackages.${system};

      specialArgs = {
        inherit hostname;
        inherit system;
        inherit username;
        inherit nix-darwin;
        inherit home-manager;
        inherit helix-master;
        inherit scls-main;
        inherit pkgs-master;
        inherit pkgs;
      };
    in {
      formatter = pkgs.nixfmt;

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${hostname}.pkgs;

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        inherit pkgs;
        inherit specialArgs;

        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username}.imports = [ ./home.nix ];
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    };

}
