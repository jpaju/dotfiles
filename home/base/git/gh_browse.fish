function gh_browse --argument-names file line_start line_end
    set current_branch (git rev-parse --abbrev-ref HEAD)

    if not branch_exists_on_remote $current_branch
        set current_branch (git_default_branch)
    end

    if test "$line_start" = "$line_end"
        set line_spec "$line_start"
    else
        set line_spec "$line_start-$line_end"
    end

    set gh_url (gh browse "$file:$line_spec" -b="$current_branch" --no-browser)
    set gh_url (string replace '?plain=1' '' $gh_url)
    if test (uname) = Darwin
        open "$gh_url"
    else
        xdg-open "$gh_url"
    end
end

function branch_exists_on_remote --argument-names branch
    git show-ref --verify --quiet refs/remotes/origin/$branch
end

