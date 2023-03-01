function find_commit_hash
	git_log_pretty --first-parent $(git branch --show-current) | fzf --ansi --reverse --preview "echo {} | cut -d ' ' -f1 | xargs -I [] git show --color --compact-summary []" | cut -d ' ' -f1
end

function git_log_pretty
	git log --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(yellow)%h %Cgreen%<(13)%cr %<(12,trunc)%C(bold blue)%an   %C(red)%s' --all --color=always $argv
end
