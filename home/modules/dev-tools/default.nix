{ pkgs, ... }: {

  imports = [
    # Comment just to keep newlines when formatted :D
    ./docker
    ./gh
    ./git
  ];

  home.packages = with pkgs; [

    # General
    coursier
    kcat
    pgcli
    tokei
    # scala-update # TODO Comment until the package is fixed and can be built

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
    metals # Scala
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

  home.file.".sbt/1.0/global.sbt".source = ./global.sbt;
}

