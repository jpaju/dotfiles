{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.typescript.enable {
    home.packages = with pkgs; [
      typescript-language-server
      vscode-langservers-extracted
      prettier
    ];

    home.file."flakes/npm/flake.nix".source = ./npm-flake.nix;
    home.file."flakes/bun/flake.nix".source = ./bun-flake.nix;
  };
}
