function find_local_branch
	git branch | grep -v -E "HEAD|\*" | fzf | string trim
end
