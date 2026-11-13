for command in git_wt_rename gwtr
    complete --command $command --condition "not __fish_seen_argument --long name" --long name --require-parameter --description "Use explicit worktree name"
    complete --command $command --condition "not __fish_seen_argument --long multiplexer-rename" --long multiplexer-rename --description "Rename current multiplexer tab too"
end
