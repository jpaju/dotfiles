{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.java.enable {
    home.packages = with pkgs; [
      jdt-language-server
    ];

    programs.fish.shellAbbrs.jps = "jps -lm";
  };
}
