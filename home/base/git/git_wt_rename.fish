function git_wt_rename
    set -l branch (current_branch)
    or return 1

    set -l new_path (worktree_path_from_branch $branch)
    set -l new_wt_name (basename $new_path)
    set -l wtpath (git rev-parse --show-toplevel)

    if test "$wtpath" = "$new_path"
        echo "Already named '$new_wt_name'"
        return 0
    end

    git worktree move "$wtpath" "$new_path"
    and cd "$new_path"
    and echo "Renamed worktree to '$new_wt_name'"
    or return 1

    if has_active_direnv
        direnv allow
    end

    if in_zellij
        set -l tab_name (string sub -l 30 $new_wt_name) # Truncated
        zellij action rename-tab $tab_name
    end
end

function current_branch
    set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    or begin
        echo >&2 "Not in a git repository"
        return 1
    end
    echo $branch
end

function worktree_path_from_branch -a branch
    set -l name (string split -r -m1 / $branch)[-1]
    set -l parent (dirname (git rev-parse --show-toplevel))
    echo "$parent/$name"
end

function has_active_direnv
    test -n "$DIRENV_FILE"
end

function in_zellij
    test -n "$ZELLIJ"
end
