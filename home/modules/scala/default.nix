{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.dotfiles.scala.enable {
    home.packages = with pkgs; [
      sbt
      coursier
      metals
      scalafmt
    ];

    home.file.".sbt/1.0/global.sbt".source = ./global.sbt;

    xdg.configFile."fish/functions/metals_reset.fish".source = ./metals_reset.fish;
  };
}
