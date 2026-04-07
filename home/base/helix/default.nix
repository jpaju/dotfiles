{
  pkgs,
  system,
  helix,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = helix.packages.${system}.default;
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "$EDITOR";
  };

  home.packages = with pkgs; [
    simple-completion-language-server # Snippets
    typos-lsp # Spellchecking
    fish-lsp # Fish
    bash-language-server # Bash
    marksman # Markdown
    mpls # Markdown preview
    nixd # Nix
    nixfmt # Nix
    taplo # TOML
    vscode-langservers-extracted # JSON, HTML, CSS, SCSS
    yaml-language-server # YAML
    prettier # JS, TS, HTML, CSS, YAML, Markdown
    lua-language-server # Lua
  ];

  xdg.configFile = {
    "helix/config.toml".source = ./config.toml;
    "helix/languages.toml".source = ./languages.toml;
    "helix/ignore".source = ./ignore;
    "helix/broot-picker.hjson".source = ./broot-picker.hjson;

    "fish/functions/yazi_picker.fish".source = ./yazi_picker.fish;
    "fish/functions/broot_picker.fish".source = ./broot_picker.fish;
    "fish/functions/open_lazygit_floating_direnv.fish".source = ./open_lazygit_floating_direnv.fish;

    "helix/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}
