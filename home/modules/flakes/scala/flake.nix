{
  description = "General flake for Scala development";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          name = "scala";
          packages = with pkgs; [ sbt temurin-bin-21 ammonite scala-cli ];

          shellHook = ''
            export SBT_TPOLECAT_DEV=1
          '';
        };
      });
}
