{ pkgs, ... }:
{
  home.packages = [ pkgs.duckdb ];

  home.file.".duckdbrc".source = ./duckdbrc;
}
