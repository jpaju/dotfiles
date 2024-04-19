{ pkgs, ... }: {

  imports = [
    # Comment just to keep newlines when formatted :D
    ./docker
    ./gh
    ./git
    ./helix
    ./intellij
  ];

  home.packages = with pkgs; [
    coursier
    kcat
    pgcli
    tokei
    # scala-update # TODO Comment until the package is fixed and can be built
  ];

  home.file.".sbt/1.0/global.sbt".source = ./global.sbt;
}

