function nix_darwin_switch
    set -l generation_before (get_current_generation)
    
    darwin-rebuild switch --flake ~/dotfiles

    set -l generation_after (get_current_generation)

    if [ $generation_before != $generation_after ]
        compare_nix_version /nix/var/nix/profiles/system $generation_before $generation_after
    else
        echo "No new generation was created."
    end
end

function get_current_generation
    set -l generations (darwin-rebuild --list-generations | string trim)
    set -l current_generation (echo $generations[-1] | string split ' ')[1]

    echo $current_generation
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

