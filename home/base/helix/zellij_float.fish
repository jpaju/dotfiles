function zellij_float
    argparse 'large' 'small' -- $argv
    or return

    if set -q _flag_large
        zellij run -fc --height 96% --width 96% -y 4% -x 2% -- fish -c "$argv" >/dev/null
    else if set -q _flag_small
        zellij run -fc --height 84% --width 74% -y 8% -x 13% -- fish -c "$argv" >/dev/null
    else
        echo "zellij_float: expected --large or --small" >&2
        return 1
    end
end
