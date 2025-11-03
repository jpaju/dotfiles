function gh_pr_switch
    argparse w/wait-on-error -- $argv

    set -x GH_FORCE_TTY 100% # Forces colored output for 'gh' command even when piped

    set -f selected_pr (
        gh pr list --limit 100 | \
        tail -n +5 | \
        fzf --ansi --preview 'gh pr view --comments {1}' --preview-window down --bind 'ctrl-j:preview-down,ctrl-k:preview-up' | \
        awk '{print substr($1, 2)}'
    )

    if test -z "$selected_pr"
        echo "No PR selected, aborting."
        return 1
    end

    # When not running in wait-on-error mode, don't wrap checkout command
    if not set --query _flag_w
        gh pr checkout $selected_pr
    else
        set output (gh pr checkout $selected_pr 2>&1)
        set checkout_status $status

        if test $checkout_status -ne 0
            echo "Checkout failed. Error:"
            echo "----------------------------------------------------------------"
            echo -n (set_color red)
            for line in $output; echo $line; end;
            echo -n (set_color normal)
            echo "----------------------------------------------------------------"

            read --local --prompt-str "Press Enter to to continue..."
            return $checkout_status
        end
    end
end
