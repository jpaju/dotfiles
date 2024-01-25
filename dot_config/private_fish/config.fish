# Set up Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# Environment variables
set -gx EDITOR "hx"
set -gx VISUAL $EDITOR
set -gx XDG_CONFIG_HOME "$HOME/.config"

if status is-interactive
    # Nix setup
    nix-your-shell fish | source

    # FZF opts
    set fzf_fd_opts --hidden --exclude=.git
    set fzf_history_time_format %d-%m-%y
    set fzf_diff_highlighter diff-so-fancy
    set fzf_history_time_format "%d.%m.%y %H:%M"
    # Add '--decorate-refs-exclude="tags/*"' to 'git log' command in _fzf_search_git_log.fish -file to exclude tags from git log search

    # Load abbreviations
    source ~/.config/fish/abbreviations.fish

    # Set up iTerm2 shell integration
    test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
end
