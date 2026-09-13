{
  pkgs,
  system,
  inputs,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${system}.default;
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
    "helix/broot-picker.hjson".source = ./functions/broot-picker.hjson;

    "fish/functions/yazi_picker.fish".source = ./functions/yazi_picker.fish;
    "fish/functions/broot_picker.fish".source = ./functions/broot_picker.fish;
    "fish/functions/open_paths_in_helix.fish".source = ./functions/open_paths_in_helix.fish;
    "fish/functions/open_popup.fish".source = ./functions/open_popup.fish;

    "helix/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}
