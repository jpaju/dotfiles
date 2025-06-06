{ pkgs, ... }: {
  home.packages = [ pkgs.claude-code ];
  home.file."./claude/settings.json".source = ./settings.json;
}

