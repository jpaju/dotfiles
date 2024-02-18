{ ... }: {
  programs.lazygit.enable = true;

  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
