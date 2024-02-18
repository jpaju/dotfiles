{ pkgs, pkgs-master, system, helix-master, scls-main, ... }: {

  imports = [
    ./modules/fish
    ./modules/flakes
    ./modules/git
    ./modules/helix
    ./modules/intellij
    ./modules/karabiner
    ./modules/iterm2
    ./modules/lazygit
    ./modules/starship
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ripgrep.enable = true;

    yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      # Terminal
      nix-your-shell

      # CLI
      bat
      curlie
      eza
      fd
      fx
      fzf
      gping
      iperf3
      jq
      ncdu
      tldr

      # Dev tools
      coursier
      gh
      gti
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
  };
}
