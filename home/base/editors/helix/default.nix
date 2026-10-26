{
  system,
  inputs,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${system}.default;
  };

  xdg.configFile = {
    "helix/config.toml".source = ./config.toml;
    "helix/languages.toml".source = ./languages.toml;
    "helix/ignore".source = ./ignore;
    "helix/broot-picker.hjson".source = ./functions/broot-picker.hjson;

    "fish/functions/yazi_picker.fish".source = ./functions/yazi_picker.fish;
    "fish/functions/broot_picker.fish".source = ./functions/broot_picker.fish;
    "fish/functions/open_paths_in_helix.fish".source = ./functions/open_paths_in_helix.fish;
    "fish/functions/open_popup.fish".source = ./functions/open_popup.fish;

    "helix/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}
