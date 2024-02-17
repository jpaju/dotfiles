{ pkgs, pkgs-master, system, helix-master, scls-main, ... }: {

  imports = [ ./modules/fish.nix ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    helix = {
      enable = true;
      package = helix-master.packages.${system}.default;
    };
  };

  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      # Terminal
      chezmoi
      nix-your-shell
      starship

      # CLI
      bat
      curlie
      eza
      fd
      fx
      fzf
      pkgs-master.helix-gpt # TODO Change to unstable when available
      gping
      iperf3
      jq
      ncdu
      tldr

      # Dev tools
      coursier
      diff-so-fancy
      gh
      git
      gti
      kcat
      lazygit
      pgcli
      # scala-update # TODO Comment until the package is fixed and can be built

      # LSPs
      dockerfile-language-server-nodejs # Docker
      elmPackages.elm-language-server # Elm
      kotlin-language-server # Kotlin
      marksman # Markdown
      metals # Scala
      nil # Nix
      nodePackages."@prisma/language-server" # Prisma
      nodePackages.bash-language-server # Bash
      nodePackages.typescript-language-server # TypeScript
      python311Packages.python-lsp-server # Python
      scls-main.defaultPackage.${system} # Snippets and words
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

