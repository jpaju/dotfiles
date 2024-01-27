{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-master = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, helix-master, ... }:
    let
      arch = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${arch};
    in {
      formatter = pkgs.nixfmt;

      homeConfigurations.jaakkopaju = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit arch;
          inherit helix-master;
        };
      };
    };

}
