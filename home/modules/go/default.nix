{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.go.enable {
    home.packages = with pkgs; [
      go
      gopls
      golangci-lint
      golangci-lint-langserver
    ];

    home.file."flakes/go/flake.nix".source = ./flake.nix;
  };
}
