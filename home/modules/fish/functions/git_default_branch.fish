
function git_default_branch
    set -l default_branch (get_default_branch)

    if test -z "$default_branch"
        # Default branch is not set locally, so we first need to set it.
        set_default_branch
        set -f default_branch (get_default_branch)
    end

    echo $default_branch
end

function set_default_branch
    # Queries the remote repository for the default branch name and sets it as the default branch locally.
    git remote set-head origin --auto >/dev/null
end

function get_default_branch
    # Parses the default branch name from the output of `git branch --remotes`.
    git branch --remotes | sed -n 's/^.*HEAD -> origin\/\([^ ]*\).*$/\1/p'
end
