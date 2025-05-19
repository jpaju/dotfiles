{ pkgs, system, helix-master, scls, ... }: {
  programs.helix = {
    enable = true;
    package = helix-master.packages.${system}.default;
  };

  home.packages = with pkgs; [
    scls.defaultPackage.${system} # Snippets and words
    typos-lsp # Spellchecking

    # Languages
    terraform
    protols

    # LSPs
    docker-compose-language-service # docker compose
    dockerfile-language-server-nodejs # Docker
    elmPackages.elm-language-server # Elm
    gopls # Go
    golangci-lint-langserver # Go linting
    jdt-language-server # Java
    kotlin-language-server # Lua
    lua-language-server # Kotlin
    marksman # Markdown
    metals # Scala
    nixd # Nix
    nil # Nix
    nodePackages.bash-language-server # Bash
    nodePackages.typescript-language-server # TypeScript
    python311Packages.python-lsp-server # Python
    regols # Open Policy Agent
    rust-analyzer # TOML
    taplo # Rust
    terraform-ls # Terraform
    vscode-langservers-extracted # JSON, HTML, CSS, SCSS
    yaml-language-server # YAML

    # Formatters
    black # Python
    nixfmt # Nix
    nodePackages.prettier # JSON, JS, TS, HTML, CSS, YAML, Markdown
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
