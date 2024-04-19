function gh_pr_switch
    set -x GH_FORCE_TTY 100% # Forces colored output for 'gh' command even when piped

    set -f selected_pr (
        gh pr list --limit 100 | \
        tail -n +5 | \
        fzf --ansi --preview 'gh pr view --comments {1}' --preview-window down --bind 'ctrl-j:preview-down,ctrl-k:preview-up' | \
        awk '{print substr($1, 2)}'
    )

    if test -z "$selected_pr"
        return 1
    end

    gh pr checkout $selected_pr
end
