{ pkgs, ... }:
{
  catppuccin.yazi.enable = true;
  catppuccin.yazi.accent = "blue";

  programs.yazi = {
    enable = true;

    initLua = ./init.lua;

    plugins = with pkgs.yaziPlugins; {
      piper = piper;
      git = git;
      vcs-files = vcs-files;
      chmod = chmod;
      starship = starship;
    };

    extraPackages = with pkgs; [
      glow
      eza
    ];

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
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];

      plugin.prepend_previewers = [
        {
          name = "*.md";
          run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
        }
        {
          name = "*/";
          run = ''piper --  eza --tree --level=3 --color=always --icons=always --group-directories-first --no-quotes --long --git --all --header "$1"'';
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
            "g"
            "c"
          ];
          run = "plugin vcs-files";
          desc = "Show Git file changes";
        }
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
