# Copied from https://yazi-rs.github.io/docs/tips/#helix-with-zellij
function yazi_picker --argument-names action target
    set -l paths (
        yazi "$target" --chooser-file=/dev/stdout | while read -l path
            string escape -- $path
        end
    )

    if test (count $paths) -gt 0
        zellij action toggle-floating-panes
        zellij action write 27 # send <Escape> key
        zellij action write-chars ":$action "(string join " " -- $paths)
        zellij action write 13 # send <Enter> key
    else
        zellij action toggle-floating-panes
    end
end
