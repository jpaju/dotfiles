function broot_picker --argument-names action
    set -l picker_conf "$HOME/.config/helix/broot-picker.hjson"
    set -l base_conf "$HOME/.config/broot/conf.hjson"
    set -l output_file (mktemp -t broot-output)

    broot --cmd ":open_preview" --conf "$picker_conf;$base_conf" --verb-output "$output_file"

    set -l paths (while read -l path
        printf '%s\n' "$path"
    end < "$output_file")
    rm -f $output_file

    if test (count $paths) -gt 0
        open_paths_in_helix $action $paths
    end
end
