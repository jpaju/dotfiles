{
  description = "General flake for Go development";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        goVersion = 22;
      in
      {
        overlays.default = final: prev: { go = final."go_1_${toString goVersion}"; };

        devShells.default = pkgs.mkShell {
          name = "go";
          packages = with pkgs; [
            go
            golangci-lint
          ];
        };
      }
    );
}
