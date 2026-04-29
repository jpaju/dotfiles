function git_wt_rename
    # Parse arguments
    set -l explicit_wt_name
    set -l explicit_wt_name_set false
    set -l should_rename_zellij_tab false
    set -l usage "Usage: git_wt_rename [--name NAME] [--zellij-rename]"

    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --name
                set i (math $i + 1)

                if test $i -gt (count $argv)
                    echo >&2 $usage
                    return 1
                end

                if string match -q -- "--*" "$argv[$i]"
                    echo >&2 $usage
                    return 1
                end

                set explicit_wt_name_set true
                set explicit_wt_name "$argv[$i]"
            case --zellij-rename
                set should_rename_zellij_tab true
            case '*'
                echo >&2 $usage
                return 1
        end

        set i (math $i + 1)
    end

    # Validate new worktree name
    if test "$explicit_wt_name_set" = true; and test -z "$explicit_wt_name"
        echo >&2 "Worktree name cannot be empty"
        return 1
    end

    if test -n "$explicit_wt_name"; and string match -q "*/*" -- "$explicit_wt_name"
        echo >&2 "Worktree name cannot contain '/'"
        return 1
    end

    # Get current worktree name and derive new one
    set -l wtpath (git rev-parse --show-toplevel)
    or begin
        echo >&2 "Not in a git repository"
        return 1
    end

    set -l new_path
    set -l new_wt_name
    if test "$explicit_wt_name_set" = true
        set -l parent (dirname $wtpath)
        set new_wt_name $explicit_wt_name
        set new_path "$parent/$new_wt_name"
    else
        set -l branch (current_branch)
        or return 1

        set new_path (worktree_path_from_branch $branch)
        set new_wt_name (basename $new_path)
    end

    # Rename worktree
    if test "$wtpath" = "$new_path"
        echo "Already named '$new_wt_name'"
        return 0
    end
    git worktree move "$wtpath" "$new_path"
    and cd "$new_path"
    and echo "Renamed worktree to '$new_wt_name'"
    or return 1

    # Allow direnv if exists
    if has_active_direnv
        direnv allow
    end

    # Rename zellij tab if requested
    if test "$should_rename_zellij_tab" = true; and in_zellij
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
