{ ... }:
{
  programs.yazi = {
    enable = true;

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

    initLua = ./init.lua;

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

  catppuccin.yazi.enable = true;
  catppuccin.yazi.accent = "blue";
}
