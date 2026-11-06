function open_popup
    set -l tool $argv[1]
    set -l args $argv[2..]

    if set -q HERDR_ENV
        herdr_popup $tool $args
    else if set -q ZELLIJ
        zellij_popup $tool $args
    else if set -q REX_SESSION
        rex_popup $tool $args
    end
end

function herdr_popup
    set -l tool $argv[1]
    set -l args $argv[2..]
    set -l popup_env \
        --env "EDITOR_ORIGIN_PANE_ID=$HERDR_PANE_ID" \
        --env "EDITOR_PICKER_ACTION=$args[1]" \
        --env "EDITOR_PREVIEW_FILE=$args[1]" \
        --env "EDITOR_PICKER_TARGET=$args[2]"

    herdr plugin pane open \
        --plugin local.popup-tools \
        --entrypoint $tool \
        --cwd "$PWD" \
        $popup_env \
        --focus >/dev/null
end

function zellij_popup
    set -l command (popup_command $argv)
    or return 1

    if test (popup_size $argv[1]) = large
        zellij run -fc --height 96% --width 96% -y 4% -x 2% -- fish -c "$command" >/dev/null
    else
        zellij run -fc --height 84% --width 74% -y 8% -x 13% -- fish -c "$command" >/dev/null
    end
end

function rex_popup
    set -l command (popup_command $argv)
    or return 1

    # Rex focuses another pane when the popup closes, so focus the editor pane after command finishes
    set -l focus_editor (string escape -- "$REX_BIN_DIR/rex") focus --session $REX_SESSION $REX_BLOCK
    set command "set -x EDITOR_ORIGIN_PANE_ID $REX_BLOCK; $command; $focus_editor"

    set -l bounds '[0.02, 0.04, 0.96, 0.96]'
    if test (popup_size $argv[1]) = small
        set bounds '[0.13, 0.08, 0.74, 0.84]'
    end

    set -l request (jq --null-input --compact-output \
        --argjson bounds "$bounds" \
        --arg cwd "$PWD" \
        --arg command "$command" \
        '{
            bounds: $bounds,
            focus: true,
            layout: {
                block: {
                    flavor: "com.superlogical.terminal.shell",
                    options: { cwd: $cwd, command: ["fish", "-c", $command] }
                }
            }
        }')

    "$REX_BIN_DIR/rex" api call --session "$REX_SESSION" session.new_layer "$request" >/dev/null
end

function popup_size --argument-names tool
    switch $tool
        case gh-pr-switch
            echo small
        case '*'
            echo large
    end
end

function popup_command
    set -l tool $argv[1]
    set -l args $argv[2..]

    switch $tool
        case lazygit
            if set -q LAZYGIT_USE_DIRENV
                echo direnv exec . lazygit $args
            else
                echo lazygit $args
            end
        case gh-dash
            echo gh dash $args
        case serpl
            echo serpl $args
        case gh-pr-switch
            echo gh_pr_switch --wait-on-error $args
        case yazi
            echo yazi_picker $args
        case broot
            echo broot_picker $args
        case leaf
            echo leaf --watch (string escape -- $args[1])
        case '*'
            echo "open_popup: unknown tool: $tool" >&2
            return 1
    end
end
