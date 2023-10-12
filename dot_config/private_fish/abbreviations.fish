# https://fishshell.com/docs/current/cmds/abbr.html

# Git
abbr --add ga 	'git add'
abbr --add gaa 	'git add --all'
abbr --add gap 	'git add --patch'
abbr --add gb 	'git branch'
abbr --add gba 	'git branch --all'
abbr --add gbr 	'git branch --remotes'
abbr --add gbd 	'git branch --delete --remotes'
abbr --add gcm 	'git commit --message'
abbr --add gca 	'git commit --amend'
abbr --add gcan 'git commit --amend --no-edit'
abbr --add gcl 	'git clone'
abbr --add gco 	'git checkout'
abbr --add gdc 	'git diff --cached'
abbr --add gdf 	'git diff'
abbr --add gf 	'git fetch'
abbr --add gfp 	'git fetch --prune'
abbr --add gi 	'git init'
abbr --add gl 	'git log --graph --abbrev-commit --decorate --format=format:"%C(bold yellow)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(bold red)%s%C(reset) %C(blue)- %an%C(reset)%C(auto)%d%C(reset)" --all'
abbr --add gm 	'git merge'
abbr --add gmff 'git merge --ff-only'
abbr --add gpl 	'git pull'
abbr --add gps 	'git push'
abbr --add gpsf 'git push --force-with-lease'
abbr --add gpst 'git push --tags'
abbr --add gpum 'git push -u origin master'
abbr --add gpuo 'git push -u origin'
abbr --add grb 	'git rebase'
abbr --add grba 'git rebase --abort'
abbr --add grbc 'git rebase --continue'
abbr --add grbi 'git rebase -i'
abbr --add gr 	'git reset'
abbr --add grh 	'git reset --hard'
abbr --add gra 	'git remote add'
abbr --add grso 'git remote set-url origin'
abbr --add grsu 'git remote set-url'
abbr --add grup 'git remote add upstream'
abbr --add grv 	'git remote -v'
abbr --add gs 	'git status'
abbr --add gsw 	'git switch'
abbr --add gtl 	'git tag --list'

# Git with fuzzy finder
abbr --add fga   'git ls-files -m -o --exclude-standard | fzf --multi --print0 | xargs -0 -o -t git add'
abbr --add fgap  'git ls-files -m -o --exclude-standard | fzf --multi --print0 | xargs -0 -o -t git add --patch'
abbr --add fgco  'git checkout $(find_local_branch)'
abbr --add fgcor 'git checkout --track $(find_remote_branch)'
abbr --add fgrb  'git rebase -i $(find_commit_hash)'
abbr --add fgr 	 'git reset $(find_commit_hash)'


# GitHub CLI
abbr --add ghb 	'gh browse'


# Docker
abbr --add dk 	'docker'
abbr --add dkb 	'docker build'

# Docker Compose
abbr --add dcu 	'docker compose up'
abbr --add dcud 'docker compose up -d'
abbr --add dcd 	'docker compose down'
abbr --add dcs  'docker compose stop'

# NPM
abbr --add nb 	'npm build'
abbr --add ncl	'npm clean'
abbr --add nd 	'npm run dev'
abbr --add nit 	'npm init'
abbr --add ni 	'npm install'
abbr --add nig	'npm install -g'
abbr --add ns 	'npm serve'
abbr --add nst 	'npm start'
abbr --add nt 	'npm test'
abbr --add nv 	'npm --version'


# Chezmoi
abbr --add cm 	'chezmoi'
abbr --add cmad 'chezmoi add'
abbr --add cmap 'chezmoi apply -v'
abbr --add cmcd 'chezmoi cd'
abbr --add cmd 	'chezmoi diff'
abbr --add cme 	'chezmoi edit'

# Misc
abbr --add jps 'jps -lm'
abbr --add reload 'exec fish'
abbr --add lt 'ls --tree --level 4'
abbr --add cb 'fish_clipboard_copy'
abbr --add cpuuid 'uuidgen | fish_clipboard_copy'
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
