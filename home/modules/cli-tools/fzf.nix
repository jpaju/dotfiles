{ pkgs, fishUtils, ... }: {
  programs = {
    fzf.enable = true;

    fish = {
      plugins = [ (fishUtils.fishPlugin pkgs "fzf-fish") ];

      interactiveShellInit = ''
        set fzf_fd_opts --hidden --exclude=.git
        set fzf_history_time_format %d-%m-%y
        set fzf_diff_highlighter delta
        set fzf_history_time_format "%d.%m.%y %H:%M"

        fzf_configure_bindings --history=
      '';
    };
  };

  home.packages = [ pkgs.fd ];
}

