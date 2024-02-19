# https://fishshell.com/docs/current/cmds/abbr.html

# Git
abbr --add ga    'git add'
abbr --add gaa   'git add --all'
abbr --add gap   'git add --patch'
abbr --add gb    'git branch'
abbr --add gba   'git branch --all'
abbr --add gbr   'git branch --remotes'
abbr --add gbd   'git branch --delete'
abbr --add gacm  'git add --all && git commit --message'
abbr --add gcm   'git commit --message'
abbr --add gca   'git commit --amend'
abbr --add gcan  'git commit --amend --no-edit'
abbr --add gcl   'git clone'
abbr --add gco   'git checkout'
abbr --add gdc   'git diff --cached'
abbr --add gdf   'git diff'
abbr --add gf    'git fetch'
abbr --add gfp   'git fetch --prune'
abbr --add glp   'git localprune'
abbr --add gi    'git init'
abbr --add gl    'git log --graph --abbrev-commit --decorate --format=format:"%C(bold yellow)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(bold red)%s%C(reset) %C(blue)- %an%C(reset)%C(auto)%d%C(reset)" --all'
abbr --add gm    'git merge'
abbr --add gmff  'git merge --ff-only'
abbr --add gpl   'git pull'
abbr --add gplu  'git pull upstream'
abbr --add gps   'git push'
abbr --add gpsf  'git push --force-with-lease'
abbr --add grb   'git rebase'
abbr --add grba  'git rebase --abort'
abbr --add grbc  'git rebase --continue'
abbr --add grbi  'git rebase --interactive'
abbr --add gr    'git reset'
abbr --add grh   'git reset --hard'
abbr --add grs   'git reset --soft'
abbr --add gra   'git remote add'
abbr --add grso  'git remote set-url origin'
abbr --add grup  'git remote add upstream'
abbr --add grv   'git remote -v'
abbr --add gsp   'git stash pop'
abbr --add gsu   'git stash --include-untracked --message'
abbr --add gs    'git status'
abbr --add gsw   'git switch'
abbr --add gswc  'git switch --create'
abbr --add gswm  'git switch (git_default_branch)'
abbr --add ggrep 'git log -p -G' # Maybe try also 'git rev-list --all | xargs git grep' ?

# GitHub CLI
abbr --add ghb   'gh browse'
abbr --add ghprc 'gh pr create --web'
abbr --add ghprv 'gh pr view --web'
abbr --add ghprm 'gh pr merge --squash --delete-branch'
abbr --add ghprs 'gh_pr_switch'
abbr --add ghrw  'gh run watch'

# Lazygit
abbr --add lg lazygit

# Docker
abbr --add dk  'docker'
abbr --add dkb 'docker build'

# Docker Compose
abbr --add dc   'docker compose'
abbr --add dcu  'docker compose up'
abbr --add dcud 'docker compose up -d'
abbr --add dcd  'docker compose down'
abbr --add dcs  'docker compose stop'

# Direnv
abbr --add de   'direnv'
abbr --add dea  'direnv allow'
abbr --add deb  'direnv block'
abbr --add des  'direnv status'

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
abbr --add reload 'exec fish'
abbr --add jps    'jps -lm'
abbr --add ya     'yazi'
abbr --add lt     'ls --tree --level 3'
abbr --add cb     'fish_clipboard_copy'
abbr --add cpuuid 'uuidgen | fish_clipboard_copy'
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
