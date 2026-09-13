function open_popup
    set -l tool $argv[1]
    set -l args $argv[2..]

    if set -q HERDR_ENV
        herdr_popup $tool $args
    else if set -q ZELLIJ
        zellij_popup $tool $args
    end
end

function herdr_popup
    set -l tool $argv[1]
    set -l args $argv[2..]
    set -l popup_env \
        --env "HELIX_ORIGIN_PANE_ID=$HERDR_PANE_ID" \
        --env "HELIX_PICKER_ACTION=$args[1]" \
        --env "HELIX_PICKER_TARGET=$args[2]"

    herdr plugin pane open \
        --plugin local.popup-tools \
        --entrypoint $tool \
        --cwd "$PWD" \
        $popup_env \
        --focus >/dev/null
end

function zellij_popup
    set -l tool $argv[1]
    set -l args $argv[2..]
    set -l size large
    set -l command

    switch $tool
        case lazygit
            if set -q LAZYGIT_USE_DIRENV
                set command direnv exec . lazygit $args
            else
                set command lazygit $args
            end
        case gh-dash
            set command gh dash $args
        case serpl
            set command serpl $args
        case gh-pr-switch
            set size small
            set command gh_pr_switch --wait-on-error $args
        case yazi
            set command yazi_picker $args
        case broot
            set command broot_picker $args
        case '*'
            echo "zellij_popup: unknown tool: $tool" >&2
            return 1
    end

    if test $size = large
        zellij run -fc --height 96% --width 96% -y 4% -x 2% -- fish -c "$command" >/dev/null
    else
        zellij run -fc --height 84% --width 74% -y 8% -x 13% -- fish -c "$command" >/dev/null
    end
end
