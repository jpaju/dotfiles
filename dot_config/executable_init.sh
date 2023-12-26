# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Nix
sh <(curl -L https://nixos.org/nix/install)
nix profile install "nixpkgs#nix-your-shell"
nix profile install "nixpkgs#nil"

# Install chezmoi which manages the dotfiles
brew install chezmoi

# Use chezmoi to copy dotfiles
chezmoi init git@github.com:JPaju/dotfiles.git
chezmoi apply -v

# Install brew packages
brew bundle install --file ~/.config/brew/Brewfile

# Install fisher packages
fish -c "fisher update"
