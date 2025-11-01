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

    # Languages
    terraform
    go
    protobuf # Required by protols

    # LSPs
    docker-language-server # docker & docker compose
    elmPackages.elm-language-server # Elm
    fish-lsp # Fish
    gopls # Go
    golangci-lint # Go linting
    golangci-lint-langserver # Go linting
    jdt-language-server # Java
    kotlin-language-server # Kotlin
    lua-language-server # Lua
    marksman # Markdown
    metals # Scala
    mpls # Markdown preview
    nixd # Nix
    nil # Nix
    bash-language-server # Bash
    typescript-language-server # TypeScript
    protols # Protobuf
    python313Packages.python-lsp-server # Python
    rust-analyzer # Rust
    taplo # TOML
    terraform-ls # Terraform
    vscode-langservers-extracted # JSON, HTML, CSS, SCSS
    yaml-language-server # YAML

    # Formatters
    black # Python
    nixfmt # Nix
    prettier # JS, TS, HTML, CSS, YAML, Markdown
    pgformatter # SQL
    scalafmt # Scala
    rustfmt # Rust
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
