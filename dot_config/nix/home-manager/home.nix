{ config, pkgs, ... }: {
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

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
      tldr

      # Dev tools
      coursier
      diff-so-fancy
      gh
      git
      gti
      helix
      kcat
      lazygit
      pgcli
      scala-update

      # Misc
      gnupg
      pinentry

      # LSPs
      dockerfile-language-server-nodejs
      elmPackages.elm-language-server
      kotlin-language-server
      marksman
      metals
      nil
      nodePackages."@prisma/language-server"
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      python311Packages.python-lsp-server
      taplo
      terraform-ls
      vscode-langservers-extracted
      yaml-language-server

      # Formatters
      black
      buf
      elmPackages.elm-format
      nixfmt
      nodePackages.prettier
      pgformatter
      scalafmt

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
