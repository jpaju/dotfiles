function whichpane --description 'Show PIDs with their terminal multiplexer ancestry'
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

    # cwd of the target pid (the project)
    set --local cwd (lsof -a -d cwd -p $pid -Fn 2>/dev/null | string match --regex '^n.*' | string sub --start 2)[1]
    test -n "$cwd"; or set cwd '?'

    # Walk parents, collecting (pid, command) child-first up to the nearest multiplexer server.
    set --local pids
    set --local cmds
    set --local multiplexer
    set --local walk $pid
    while test -n "$walk" -a "$walk" != 1 -a "$walk" != 0
        set --local cmd (ps -o command= -p $walk 2>/dev/null)
        set --append pids $walk
        set --append cmds $cmd
        if string match --quiet '*zellij*--server*' -- "$cmd"
            set multiplexer zellij
            break
        else if string match --quiet --regex '(^|/)herdr server($| )' -- "$cmd"
            set multiplexer herdr
            break
        end
        set walk (ps -o ppid= -p $walk 2>/dev/null | string trim)
    end

    set --local zellij_pane '?'
    if test "$multiplexer" = zellij
        set --local env_line (ps -E -p $pid 2>/dev/null)
        set zellij_pane (string match --regex 'ZELLIJ_PANE_ID=(\S*)' -- "$env_line")[2]
        test -n "$zellij_pane"; or set zellij_pane '?'
    end

    set --local herdr_context
    if test "$multiplexer" = herdr
        set herdr_context (_whichpane_herdr_context $pids)
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
        set --local metadata
        if string match --quiet '*zellij*--server*' -- "$cmd"
            set --local srvpath (string match --regex -- '--server\s+(\S+)' "$cmd")[2]
            set --local session (path basename $srvpath)
            set label "zellij session: $session"
            set note "  [pane=$zellij_pane]"
            if test "$zellij_pane" != '?'
                set --local tab (zellij --session $session action list-panes --tab --json 2>/dev/null | jq -r --argjson id $zellij_pane 'first(.[] | select((.is_plugin | not) and .id == $id)) | .tab_name' 2>/dev/null)
                if test -n "$tab" -a "$tab" != null
                    set note "  [tab=$tab pane=$zellij_pane]"
                end
            end
        else if string match --quiet --regex '(^|/)herdr server($| )' -- "$cmd"
            set label 'herdr server'
            if test -n "$herdr_context"
                set --local fields (string split \t -- "$herdr_context")
                set label "herdr session: $fields[1]"
                set metadata \
                    "workspace: $fields[2]" \
                    "tab:       $fields[3]" \
                    "pane:      $fields[4]"
            end
        else if test "$p" = "$pid"
            set note "  [cwd=$cwd]"
        end

        echo "$indent$branch$label  (pid $p)$note"
        for item in $metadata
            echo "  $item"
        end
        set depth (math $depth + 1)
    end
end

function _whichpane_herdr_context
    type --query herdr jq; or return 1

    set --local ancestry $argv
    set --local sessions (herdr session list --json 2>/dev/null | jq -r '.sessions[] | select(.running) | .name' 2>/dev/null)
    for session in $sessions
        set --local snapshot (herdr --session $session api snapshot 2>/dev/null); or continue
        set --local pane_ids (printf '%s\n' "$snapshot" | jq -r '.result.snapshot.panes[].pane_id' 2>/dev/null)
        for pane_id in $pane_ids
            set --local process_info (herdr --session $session pane process-info --pane $pane_id 2>/dev/null); or continue
            set --local shell_pid (printf '%s\n' "$process_info" | jq -r '.result.process_info.shell_pid // empty' 2>/dev/null)
            contains -- "$shell_pid" $ancestry; or continue

            set --local details (printf '%s\n' "$snapshot" | jq -r --arg pane "$pane_id" '
                .result.snapshot as $snapshot
                | $snapshot.panes[]
                | select(.pane_id == $pane)
                | .workspace_id as $workspace_id
                | .tab_id as $tab_id
                | [
                    ($snapshot.workspaces[] | select(.workspace_id == $workspace_id) | .label),
                    ($snapshot.tabs[] | select(.tab_id == $tab_id) | .label),
                    (.label // .agent // .terminal_title_stripped // "unnamed")
                  ]
                | @tsv
            ' 2>/dev/null)
            test -n "$details"; or continue
            printf '%s\t%s\n' "$session" "$details"
            return 0
        end
    end

    return 1
end
