{ pkgs, ... }:
{
  programs.yazi = {
    plugins.git = pkgs.yaziPlugins.git;

    settings.plugin.prepend_fetchers = [
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
  };
}
