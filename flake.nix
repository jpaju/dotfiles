{
  description = "Darwin system flake";

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scls = {
      url = "github:estin/simple-completion-language-server/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nix-darwin, nixpkgs-master, home-manager, helix-master, scls, sops-nix, ... }:
    let
      system = "aarch64-darwin";
      username = "jaakkopaju";
      userhome = "/Users/${username}";

      pkgs-master = import nixpkgs-master { inherit system; };

      fishUtils = import "${self}/util/fish.nix";

      specialArgs = {
        inherit system;
        inherit username;
        inherit userhome;
        inherit nix-darwin;
        inherit home-manager;
        inherit sops-nix;
        inherit helix-master;
        inherit scls;
        inherit pkgs-master;
        inherit fishUtils;
      };

      homeManagerOptions = homeModules: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username}.imports = homeModules;
          extraSpecialArgs = specialArgs;
          backupFileExtension = "bak";
        };
      };
    in {

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations.${hostname}.pkgs;

      darwinConfigurations = {

        "Jaakkos-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          inherit specialArgs;

          modules = let
            hmModules = [ ./home/personal.nix ];
            hmOpts = homeManagerOptions hmModules;
          in [ ./system/personal.nix home-manager.darwinModules.home-manager hmOpts ];
        };

        "Wolt-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          inherit specialArgs;

          modules = let
            hmModules = [ ./home/work.nix ];
            hmOpts = homeManagerOptions hmModules;
          in [ ./system/work.nix home-manager.darwinModules.home-manager hmOpts ];
        };
      };
    };

}
