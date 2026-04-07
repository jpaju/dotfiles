{
  description = "General flake for TypeScript development with NPM and node";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "pnpm/node";
          packages = [
            pkgs.nodejs_24
            pkgs.pnpm
          ];
        };
      }
    );
}
