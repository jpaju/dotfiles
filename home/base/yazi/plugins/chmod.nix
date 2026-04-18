{ pkgs, ... }:
{
  programs.yazi = {
    plugins.chmod = pkgs.yaziPlugins.chmod;

    keymap.mgr.prepend_keymap = [
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
}
