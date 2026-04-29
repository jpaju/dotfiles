for command in git_wt_rename gwtr
    complete --command $command --condition "not __fish_seen_argument --long name" --long name --require-parameter --description "Use explicit worktree name"
    complete --command $command --condition "not __fish_seen_argument --long zellij-rename" --long zellij-rename --description "Rename current Zellij tab too"
end
