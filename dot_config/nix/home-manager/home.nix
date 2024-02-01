{ config, pkgs, arch, helix-master, scls-main, ... }: {
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.helix = {
    enable = true;
    package = helix-master.packages.${arch}.default;
  };

  home = {
    username = "jaakkopaju";
    homeDirectory = "/Users/jaakkopaju";
    stateVersion = "23.11";

    packages = with pkgs; [
      # Terminal
      chezmoi
      fish
      nix-your-shell
      starship
      # iterm2

      # CLI
      bat
      curlie
      eza
      fd
      # fisher
      fx
      fzf
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

      # Misc
      gnupg
      pinentry

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
      scls-main.defaultPackage.${arch} # Snippets and words
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

      # GUIs currently managed with homebrew due to Nix limitations
      # aldente
      # alt-tab
      # appcleaner
      # bartender
      # dash
      # docker
      # firefox
      # font-fira-code-nerd-font
      # google-chrome
      # iterm2
      # jetbrains-toolbox
      # karabiner-elements
      # menubarx
      # monitorcontrol
      # notion
      # numi
      # postman
      # rectangle
      # signal
      # spotify
      # stats
      # visual-studio-code
    ];
  };
}
