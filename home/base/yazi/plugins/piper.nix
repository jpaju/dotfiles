{ pkgs, ... }:
{
  programs.yazi = {
    plugins.piper = pkgs.yaziPlugins.piper;

    settings.plugin.prepend_previewers = [
      {
        url = "*.md";
        run = ''piper -- leaf --inline "ansi:$w" "$1"'';
      }
      {
        url = "*/";
        run = ''piper --  eza --tree --level=2 --color=always --icons=always --group-directories-first "$1"'';
      }
    ];
  };
}
