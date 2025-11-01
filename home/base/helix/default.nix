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
    docker-language-server # docker & docker compose
    marksman # Markdown
    mpls # Markdown preview
    nixd # Nix
    nil # Nix
    nixfmt # Nix
    taplo # TOML
    vscode-langservers-extracted # JSON, HTML, CSS, SCSS
    yaml-language-server # YAML
    prettier # JS, TS, HTML, CSS, YAML, Markdown
    jdt-language-server # Java
    lua-language-server # Lua
  ];

  xdg.configFile = {
    "helix/config.toml".source = ./config.toml;
    "helix/languages.toml".source = ./languages.toml;
    "helix/ignore".source = ./ignore;

    "helix/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}
