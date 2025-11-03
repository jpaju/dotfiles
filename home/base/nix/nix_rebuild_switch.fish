function nix_rebuild_switch
    set -l generation_before (get_current_generation)

    if is_darwin
        sudo darwin-rebuild switch --flake ~/dotfiles
    else
        sudo nixos-rebuild switch
    end

    set -l generation_after (get_current_generation)

    if [ $generation_before != $generation_after ]
        compare_nix_version /nix/var/nix/profiles/system $generation_before $generation_after
    else
        echo "No new generation was created."
    end
end

function get_current_generation
    if is_darwin
        set current_generation (sudo darwin-rebuild --list-generations | sed -n '$p' | awk '{print $1}')
        echo $current_generation
    else
        set current_generation (nixos-rebuild list-generations | sed -n '2p' | awk '{print $1}')
        echo $current_generation
    end
end

function compare_nix_version --description "Compare two Nix generations using nvd" --argument-names path gen1 gen2
    if [ (count $path $gen1 $gen2) -ne 3 ]
        echo "Usage: compare_nix_generations <path> <generation1> <generation2>"
        return 1
    end

    set -l full_path1 $path-$gen1-link
    set -l full_path2 $path-$gen2-link

    nvd diff $full_path1 $full_path2
end

function is_darwin
    uname -a | string match -q "*Darwin*"
end
