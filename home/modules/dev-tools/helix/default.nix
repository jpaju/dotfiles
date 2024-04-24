{ pkgs, pkgs-master, system, helix-master, scls-main, ... }: {
  programs.helix = {
    enable = true;
    package = helix-master.packages.${system}.default;
  };

  home.packages = with pkgs; [
    scls-main.defaultPackage.${system} # Snippets and words
    typos-lsp # Spellchecking

    # Languages
    terraform

    # LSPs
    docker-compose-language-service # docker compose
    dockerfile-language-server-nodejs # Docker
    elmPackages.elm-language-server # Elm
    jdt-language-server # Java
    kotlin-language-server # Lua
    lua-language-server # Kotlin
    marksman # Markdown
    pkgs-master.metals # Scala
    nil # Nix
    nodePackages."@prisma/language-server" # Prisma
    nodePackages.bash-language-server # Bash
    nodePackages.typescript-language-server # TypeScript
    python311Packages.python-lsp-server # Python
    rust-analyzer # TOML
    taplo # Rust
    terraform-ls # Terraform
    vscode-langservers-extracted # JSON, HTML, CSS, SCSS
    yaml-language-server # YAML

    # Formatters
    black # Python
    elmPackages.elm-format # Elm
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
