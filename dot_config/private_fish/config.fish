if status is-interactive
    # Commands to run in interactive sessions can go here
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# Environment variables
set -gx EDITOR "code --wait"
set -gx VISUAL $EDITOR
fish_add_path ~/Library/Application\ Support/JetBrains/Toolbox/scripts

# Load abbreviations
source ~/.config/fish/abbreviations.fish

# Setup starship prompt
starship init fish | source
enable_transience
