function git_default_branch
    git branch --remote | sed -n 's/^.*HEAD -> origin\/\([^ ]*\).*$/\1/p'
end
