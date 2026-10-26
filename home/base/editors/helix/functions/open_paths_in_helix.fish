function open_paths_in_helix
    set -l action $argv[1]
    set -l paths $argv[2..]

    test (count $paths) -gt 0
    or return

    set -l quoted_paths
    for path in $paths
        if string match -qr '[\x00-\x1f\x7f]' -- "$path"
            echo "open_paths_in_helix: path contains control characters" >&2
            return 1
        end

        set -l escaped_path (string replace --all "'" "''" -- "$path")
        set -a quoted_paths "'$escaped_path'"
    end

    set -l command ":$action -- "(string join ' ' -- $quoted_paths)

    if set -q HELIX_ORIGIN_PANE_ID
        set -l herdr_bin herdr
        if set -q HERDR_BIN_PATH
            set herdr_bin $HERDR_BIN_PATH
        end

        $herdr_bin pane send-keys $HELIX_ORIGIN_PANE_ID esc >/dev/null
        and $herdr_bin pane send-text $HELIX_ORIGIN_PANE_ID "$command" >/dev/null
        and $herdr_bin pane send-keys $HELIX_ORIGIN_PANE_ID enter >/dev/null
    else if set -q ZELLIJ
        zellij action toggle-floating-panes
        zellij action write 27
        zellij action write-chars "$command"
        zellij action write 13
    end
end
