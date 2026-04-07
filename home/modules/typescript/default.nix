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

    programs.fish.shellAbbrs = {
      nr = "pnpm run";
      nit = "pnpm init";
      ni = "pnpm install";
      nb = "pnpm run build";
      nc = "pnpm run compile";
      nd = "pnpm run dev";
      nst = "pnpm run start";
      nt = "pnpm run test";
      nti = "pnpm run test:integration";
      nv = "pnpm --version";
    };

    home.file."flakes/npm/flake.nix".source = ./npm-flake.nix;
    home.file."flakes/bun/flake.nix".source = ./bun-flake.nix;
  };
}
