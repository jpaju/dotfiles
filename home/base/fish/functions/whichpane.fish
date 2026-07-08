function whichpane --description 'Show PIDs with their zellij ancestry'
    if test (count $argv) -eq 0
        echo "usage: whichpane <pid>..." >&2
        return 2
    end

    set --local status_code 0
    set --local first true
    for pid in $argv
        if test $first = true
            set first false
        else
            echo
        end
        _whichpane_one $pid; or set status_code 1
    end
    return $status_code
end

function _whichpane_one --argument-names pid
    if test -z (ps -o pid= -p $pid 2>/dev/null | string trim)
        echo "whichpane: no such pid: $pid" >&2
        return 1
    end

    # pane id from inherited env (for annotating the server node)
    set --local env_line (ps -E -p $pid 2>/dev/null)
    set --local pane (string match --regex 'ZELLIJ_PANE_ID=(\S*)' -- "$env_line")[2]
    test -n "$pane"; or set pane '?'

    # cwd of the target pid (the project)
    set --local cwd (lsof -a -d cwd -p $pid -Fn 2>/dev/null | string match --regex '^n.*' | string sub --start 2)[1]
    test -n "$cwd"; or set cwd '?'

    # walk parents, collecting (pid, command) child-first up to the zellij server
    set --local pids
    set --local cmds
    set --local walk $pid
    while test -n "$walk" -a "$walk" != 1 -a "$walk" != 0
        set --local cmd (ps -o command= -p $walk 2>/dev/null)
        set --append pids $walk
        set --append cmds $cmd
        if string match --quiet '*zellij*--server*' -- "$cmd"
            break
        end
        set walk (ps -o ppid= -p $walk 2>/dev/null | string trim)
    end

    # print root-first, indented
    set --local depth 0
    for i in (seq (count $pids) -1 1)
        set --local p $pids[$i]
        set --local cmd $cmds[$i]

        set --local indent ''
        set --local branch ''
        if test $depth -gt 0
            set indent (string repeat --count $depth '  ')
            set branch '└─ '
        end

        set --local label (string sub --length 70 -- "$cmd")
        set --local note ''
        if string match --quiet '*zellij*--server*' -- "$cmd"
            set --local srvpath (string match --regex -- '--server\s+(\S+)' "$cmd")[2]
            set --local session (path basename $srvpath)
            set label "zellij session: $session"
            set note "  [pane=$pane]"
            if test "$pane" != '?'
                set --local tab (zellij --session $session action list-panes --tab --json 2>/dev/null | jq -r --argjson id $pane 'first(.[] | select((.is_plugin | not) and .id == $id)) | .tab_name' 2>/dev/null)
                if test -n "$tab" -a "$tab" != null
                    set note "  [tab=$tab pane=$pane]"
                end
            end
        else if test "$p" = "$pid"
            set note "  [cwd=$cwd]"
        end

        echo "$indent$branch$label  (pid $p)$note"
        set depth (math $depth + 1)
    end
end
