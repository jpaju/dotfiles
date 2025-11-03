{
  description = "A simple flake for Rust development";

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
          name = "rust";
          packages = with pkgs; [
            rustc
            cargo
            openssl
            pkg-config
          ];
        };
      }
    );
}
