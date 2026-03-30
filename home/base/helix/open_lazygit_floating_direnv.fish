function open_lazygit_floating_direnv
    set -l zj_args -fc --height 96% --width 96% -y 4% -x 2%
    if set -q LAZYGIT_USE_DIRENV
        zellij run $zj_args -- direnv exec . lazygit $argv
    else
        zellij run $zj_args -- lazygit $argv
    end
end
