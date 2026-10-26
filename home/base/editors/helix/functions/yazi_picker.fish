# Copied from https://yazi-rs.github.io/docs/tips/#helix-with-zellij
function yazi_picker --argument-names action target
    set -l paths (yazi "$target" --chooser-file=/dev/stdout)

    if test (count $paths) -gt 0
        open_paths_in_helix $action $paths
    end
end
