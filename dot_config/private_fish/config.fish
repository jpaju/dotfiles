if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set up Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# Environment variables
set -gx EDITOR "hx"
set -gx VISUAL $EDITOR
fish_add_path ~/Library/Application\ Support/JetBrains/Toolbox/scripts

# FZF opts
set fzf_fd_opts --hidden --exclude=.git
set fzf_history_time_format %d-%m-%y
set fzf_diff_highlighter diff-so-fancy
# Add '--decorate-refs-exclude="tags/*"' to 'git log' command in _fzf_search_git_log.fish -file to exclude tags from git log search

# Load abbreviations
source ~/.config/fish/abbreviations.fish

# Set up iTerm2 shell integration
test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# Nix setup
nix-your-shell fish | source
