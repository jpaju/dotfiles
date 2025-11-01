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

    xdg.configFile."flakes/npm/flake.nix".source = ./npm-flake.nix;
    xdg.configFile."flakes/bun/flake.nix".source = ./bun-flake.nix;
  };
}
