# Opens paths in the editor pane that started the picker popup.
# Types `:<action> -- '<path>'...` into that pane and presses Enter, like a user would.
# This depends on Helix's command mode, so it works with Helix and Mitos (a Helix fork).
#
# Supported multiplexers:
# - herdr: sends keys to the pane in $EDITOR_ORIGIN_PANE_ID, which open_popup sets
# - zellij: closes the floating popup, then types into the pane that has focus
function open_paths_in_editor
    set -l action $argv[1]
    set -l paths $argv[2..]

    test (count $paths) -gt 0
    or return

    set -l quoted_paths
    for path in $paths
        if string match -qr '[\x00-\x1f\x7f]' -- "$path"
            echo "open_paths_in_editor: path contains control characters" >&2
            return 1
        end

        set -l escaped_path (string replace --all "'" "''" -- "$path")
        set -a quoted_paths "'$escaped_path'"
    end

    set -l command ":$action -- "(string join ' ' -- $quoted_paths)

    if set -q EDITOR_ORIGIN_PANE_ID
        set -l herdr_bin herdr
        if set -q HERDR_BIN_PATH
            set herdr_bin $HERDR_BIN_PATH
        end

        $herdr_bin pane send-keys $EDITOR_ORIGIN_PANE_ID esc >/dev/null
        and $herdr_bin pane send-text $EDITOR_ORIGIN_PANE_ID "$command" >/dev/null
        and $herdr_bin pane send-keys $EDITOR_ORIGIN_PANE_ID enter >/dev/null
    else if set -q ZELLIJ
        zellij action toggle-floating-panes
        zellij action write 27
        zellij action write-chars "$command"
        zellij action write 13
    end
end
