# Configure $PATH by appending package manager paths Fish executes files in
# 'conf.d' folder in alphabetical order. Other scripts may depend on programs
# installed by package managers, so we make sure they are on $PATH first.

# Set up Nix
if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

if status is-interactive
    nix-your-shell fish | source
end

# Set up Homebrew
eval (/opt/homebrew/bin/brew shellenv)
