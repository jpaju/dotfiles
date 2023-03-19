# Dotfiles

This is my personal dotfiles repository. The files are managed with [chezmoi](https://www.chezmoi.io).


## Fresh install
1. Install [homebrew](https://brew.sh)
2. Install chezmoi with `brew install chezmoi`
3. Clone this repository with `chezmoi init git@github.com:JPaju/dotfiles.git`
4. Check what modifications will be made with `chezmoi diff` and apply them with `chezmoi apply -v`
5. Install brew packages with `brew bundle install --file ~/.config/brew/Brewfile`
6. Configure iTerm2
	* [Load preferences from custom URL](https://iterm2.com/documentation-preferences-general.html): `~/.config/iterm2/com.googlecode.iterm2.plist`
	* Set up fish [shell integration](https://iterm2.com/documentation-shell-integration.html)
7. Install packages managed by fisher by running the command `fisher update`


## Add file to chezmoi
Run `chezmoi add <file>` to add a file to chezmoi. This will copy the file to the dotfiles repository and add it to the git repository. After file is added, it must be commited by first running `chezmoi cd` to change directory to the dotfiles repository and then running `git add .` and `git commit -m <commit-message>`.


## Edit local file
Changes to files tracked by chezmoi can be done in two ways:
1. Edit the file directly. After they need to be added to chezmoi with `chezmoi add <file>`.
2. Run `chezmoi edit <file>` to open the file for editing. After the edits are saved, they must be applied to the local dotfiles with `chezmoi apply`.


## Sync local changes to remote
```bash
$ chezmoi cd
$ git add .
$ git commit -m <commit-message>
$ git push
```


## Sync remote changes to local
Run `chezmoi update -v` to update the local dotfiles


## Update the brew packages to currently installed packages
1. Run `brew bundle dump --file ~/.config/brew/Brewfile` to update the Brewfile
	1. If the file already exists and you want to overwrite it, run the command with the `--force` flag
	2. If the folder doesn't exist, create it with `mkdir -p ~/.config/brew`
2. Run `chezmoi add ~/.config/brew/Brewfile`
3. Sync changes to remote [instructions above](#sync-local-changes-to-remote)
