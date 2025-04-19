{ pkgs, ... }: {

  imports = [
    # Comment just to keep newlines when formatted :D
    ./docker
    ./gh
    ./git
    ./helix
    ./intellij
  ];

  home.packages = with pkgs; [ coursier kcat pgcli tokei ];

  home.file.".sbt/1.0/global.sbt".source = ./global.sbt;
}

