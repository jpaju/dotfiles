if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set up Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# Setup sdkman
set -gx SDKMAN_DIR (brew --prefix sdkman-cli)/libexec
set -g sdkman_prefix $SDKMAN_DIR
sdk current java > /dev/null # This adds java binary to PATH and sets JAVA_HOME variable

# Environment variables
set -gx EDITOR "code --wait"
set -gx VISUAL $EDITOR
fish_add_path ~/Library/Application\ Support/JetBrains/Toolbox/scripts

# Load abbreviations
source ~/.config/fish/abbreviations.fish

# Set up iTerm2 shell integration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# Setup starship prompt
starship init fish | source
enable_transience
