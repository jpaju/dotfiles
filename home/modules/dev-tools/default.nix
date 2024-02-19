{ pkgs, ... }: {

  home.packages = with pkgs; [

    # General
    coursier
    gh
    kcat
    pgcli
    tokei
    # scala-update # TODO Comment until the package is fixed and can be built

    # Languages
    terraform

    # LSPs
    dockerfile-language-server-nodejs # Docker
    elmPackages.elm-language-server # Elm
    jdt-language-server # Java
    kotlin-language-server # Kotlin
    marksman # Markdown
    metals # Scala
    nil # Nix
    nodePackages."@prisma/language-server" # Prisma
    nodePackages.bash-language-server # Bash
    nodePackages.typescript-language-server # TypeScript
    python311Packages.python-lsp-server # Python
    taplo # TOML
    rust-analyzer # Rust
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
}

