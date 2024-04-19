# https://fishshell.com/docs/current/cmds/abbr.html

# NPM
abbr --add nit 'npm init'
abbr --add ni  'npm install'
abbr --add nb  'npm run build'
abbr --add nd  'npm run dev'
abbr --add nst 'npm run start'
abbr --add nt  'npm run test'
abbr --add nv  'npm --version'

# Nix
abbr --add nxsh  'nix shell nixpkgs#'
abbr --add nxd   'nix develop'
abbr --add nxdbn 'nix develop path:$HOME/flakes/bun'
abbr --add nxdsc 'nix develop github:devinsideyou/scala-seed#java17'
abbr --add nxdts 'nix develop path:$HOME/flakes/typescript'
abbr --add nxdpy 'nix develop path:$HOME/flakes/python'
abbr --add nxdrs 'nix develop path:$HOME/flakes/rust'

# Nix darwin
abbr --add nds 'darwin-rebuild switch --flake ~/dotfiles'
abbr --add ndu 'nix flake update --flake ~/dotfiles'

# Misc
abbr --add cb     'fish_clipboard_copy'
abbr --add cpuuid 'uuidgen | fish_clipboard_copy'
abbr --add jps    'jps -lm'
abbr --add loc    'tokei'
abbr --add lt     'ls --tree --level 3'
abbr --add reload 'exec fish'
abbr --add utcnow 'date -u +%Y-%m-%dT%H:%M:%SZ'
abbr --add ya     'yazi'
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
