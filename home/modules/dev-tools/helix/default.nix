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

    # LSPs
    docker-language-server # docker & docker compose
    elmPackages.elm-language-server # Elm
    fish-lsp # Fish
    jdt-language-server # Java
    kotlin-language-server # Kotlin
    lua-language-server # Lua
    marksman # Markdown
    mpls # Markdown preview
    nixd # Nix
    nil # Nix
    bash-language-server # Bash
    taplo # TOML
    vscode-langservers-extracted # JSON, HTML, CSS, SCSS
    yaml-language-server # YAML

    # Formatters
    nixfmt # Nix
    prettier # JS, TS, HTML, CSS, YAML, Markdown
    pgformatter # SQL
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
