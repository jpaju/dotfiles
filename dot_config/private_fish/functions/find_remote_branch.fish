function find_remote_branch
	git branch --remotes | grep -v "HEAD" | fzf | string trim
end
