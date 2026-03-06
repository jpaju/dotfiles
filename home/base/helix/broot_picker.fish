function broot_picker --argument-names action
    set -l picker_conf "$HOME/.config/helix/broot-picker.hjson"
    set -l base_conf "$HOME/.config/broot/conf.hjson"
    set -l output_file (mktemp -t broot-output)

    broot --cmd ":open_preview" --conf "$picker_conf;$base_conf" --verb-output "$output_file"

    set -l paths (while read -l path
        string escape -- $path
    end < "$output_file")
    rm -f $output_file

    if test (count $paths) -gt 0
        zellij action toggle-floating-panes
        zellij action write 27
        zellij action write-chars ":$action "(string join " " -- $paths)
        zellij action write 13
    else
        zellij action toggle-floating-panes
    end
end
