{ ... }:
{
  imports = [
    ./plugins/git.nix
    ./plugins/chmod.nix
    ./plugins/piper.nix
    ./plugins/duckdb.nix
  ];

  catppuccin.yazi.enable = true;
  catppuccin.yazi.accent = "blue";

  programs.fish.shellAbbrs.ya = "yazi";

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    initLua = ./init.lua;

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
    };

    keymap = {
      input.prepend_keymap = [
        {
          run = "close";
          on = [ "<Esc>" ];
          desc = "Cancel input";
        }
      ];
    };
  };
}
