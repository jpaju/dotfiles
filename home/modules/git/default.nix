{ ... }: {
  programs.git = {
    enable = true;
    delta.enable = true;
  };

  home.file.".gitconfig".source = ./.gitconfig;

  xdg.configFile."git/hooks/pre-push" = {
    source = ./pre-push;
    executable = true;
  };
}
