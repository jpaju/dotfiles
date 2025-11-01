function gitignore-flake
    if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
        echo "Not inside a Git repository. Aborting..."
        return 1
    end

    assume_unchanged flake.nix
    assume_unchanged flake.lock
end

function assume_unchanged --argument-names file_name
    set file_created 0
    if not test -e $file_name
        echo "'$file_name' doesn't exist, creating temporary file..."
        touch $file_name
        set file_created 1
    end

    git add --intent-to-add $file_name
    git update-index --assume-unchanged $file_name
    echo "Marked '$file_name' as assume-unchanged in Git index."

    if test $file_created -eq 1
        echo "Removing temporary file '$file_name'..."
        rm $file_name
    end
end
