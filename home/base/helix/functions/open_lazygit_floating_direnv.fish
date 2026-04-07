function open_lazygit_floating_direnv
    if set -q LAZYGIT_USE_DIRENV
        zellij_float --large -- direnv exec . lazygit $argv
    else
        zellij_float --large -- lazygit $argv
    end
end
