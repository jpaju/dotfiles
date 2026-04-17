{ pkgs, ... }:
{
  catppuccin.yazi.enable = true;
  catppuccin.yazi.accent = "blue";

  programs.fish.shellAbbrs.ya = "yazi";

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    initLua = ./init.lua;

    plugins = {
      inherit (pkgs.yaziPlugins)
        git
        chmod
        duckdb
        piper
        ;
    };

    settings = {
      mgr = {
        ratio = [
          1
          2
          3
        ];
        show_hidden = true;
        show_symlink = true;
      };

      plugin.prepend_fetchers = [
        {
          id = "git";
          url = "*";
          run = "git";
          group = "git";
        }
        {
          id = "git";
          url = "*/";
          run = "git";
          group = "git";
        }
      ];

      plugin.prepend_previewers = [
        {
          url = "*.md";
          run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
        }
        {
          url = "*/";
          run = ''piper --  eza --tree --level=2 --color=always --icons=always --group-directories-first "$1"'';
        }
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

      plugin.prepend_preloaders = [
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

    keymap = {
      input.prepend_keymap = [
        {
          run = "close";
          on = [ "<Esc>" ];
          desc = "Cancel input";
        }
      ];

      mgr.prepend_keymap = [
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };
  };
}
