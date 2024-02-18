{ pkgs, system, helix-master, scls-main, ... }: {
  programs.helix = {
    enable = true;
    package = helix-master.packages.${system}.default;
  };

  home.packages = [
    pkgs.helix-gpt # Copilot/GPT suggestions
    scls-main.defaultPackage.${system} # Snippets and words
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
