# Dotfiles

This is my personal dotfiles repository. The files are managed with [chezmoi](https://www.chezmoi.io).


## Fresh install
1. Install [homebrew](https://brew.sh)
2. Install chezmoi with `brew install chezmoi`
3. Clone this repository with `chezmoi init https://github.com/JPaju/dotfiles.git`
4. Check what modifications will be made with `chezmoi diff` and apply them with `chezmoi apply -v`
5. Install brew packages with `brew bundle install --file ~/.config/brew/Brewfile`


## Sync local changes to remote
```bash
$ chezmoi cd
$ git add .
$ git commit -m <commit-message>
$ git push
```


## Sync remote changes to local
Run `chezmoi update -v` to update the local dotfiles


## Edit local file
1. Run `chezmoi edit <file>`
2. Sync changes to remote [instructions above](#sync-local-changes-to-remote)


## Update the brew packages to currently installed packages
1. Run `brew bundle dump --file ~/.config/brew/Brewfile` to update the Brewfile
	1. If the file already exists and you want to overwrite it, run the command with the `--force` flag
	2. If the folder doesn't exist, create it with `mkdir -p ~/.config/brew`
2. Run `chezmoi add ~/.config/brew/Brewfile`
3. Sync changes to remote [instructions above](#sync-local-changes-to-remote)
