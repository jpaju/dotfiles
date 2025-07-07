{ ... }: {
  programs.opencode = {
    enable = true;
    settings = {
      autoshare = false;
      autoupdate = true;
      theme = "tokyonight";
    };
  };

  programs.fish.shellAbbrs.oc = "opencode";
}
