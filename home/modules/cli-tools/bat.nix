{ pkgs, ... }: {
  programs.fish = {
    shellAliases.cat = "bat";
    interactiveShellInit = "batman --export-env | source";
  };

  programs.bat = {
    enable = true;
    extraPackages = [ pkgs.bat-extras.batman ];

    config.theme = "catppuccin-macchiato";
    themes.catppuccin-macchiato = { # TODO Remove this once https://github.com/sharkdp/bat/pull/3317 is merged
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
        sha256 = "sha256-s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
      };
      file = "themes/Catppuccin Macchiato.tmTheme";
    };
  };
}
