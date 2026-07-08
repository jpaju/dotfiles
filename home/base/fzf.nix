{ pkgs, fishUtils, ... }:
{
  home.packages = [ pkgs.fd ];

  programs.fzf.enable = true;
  programs.fzf.historyWidget.command = "";
  programs.fzf.defaultOptions =
    let
      keybindings = [ "--bind ctrl-a:toggle-all" ];
      # fzf-fish only applies its defaults when FZF_DEFAULT_OPTS is unset
      fzfFishOptions = [
        "--cycle"
        "--layout=reverse"
        "--border"
        "--height=90%"
        "--preview-window=wrap"
        "--marker=*"
      ];
    in
    keybindings ++ fzfFishOptions;

  programs.fish.plugins = [ (fishUtils.fishPlugin pkgs "fzf-fish") ];
  programs.fish.interactiveShellInit = ''
    set fzf_fd_opts --hidden --exclude=.git
    set fzf_history_time_format %d-%m-%y
    set fzf_diff_highlighter delta
    set fzf_history_time_format "%d.%m.%y %H:%M"

    fzf_configure_bindings --history=
  '';
}
