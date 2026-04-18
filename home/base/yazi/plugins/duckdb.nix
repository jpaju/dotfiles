{ pkgs, ... }:
{
  programs.yazi = {
    plugins.duckdb = pkgs.yaziPlugins.duckdb;

    settings.plugin.prepend_previewers = [
      {
        url = "*.csv";
        run = "duckdb";
      }
      {
        url = "*.tsv";
        run = "duckdb";
      }
      {
        url = "*.parquet";
        run = "duckdb";
      }
      {
        url = "*.db";
        run = "duckdb";
      }
      {
        url = "*.duckdb";
        run = "duckdb";
      }
    ];

    settings.plugin.prepend_preloaders = [
      {
        url = "*.csv";
        run = "duckdb";
        multi = false;
      }
      {
        url = "*.tsv";
        run = "duckdb";
        multi = false;
      }
      {
        url = "*.parquet";
        run = "duckdb";
        multi = false;
      }
      {
        url = "*.db";
        run = "duckdb";
        multi = false;
      }
      {
        url = "*.duckdb";
        run = "duckdb";
        multi = false;
      }
    ];
  };
}
