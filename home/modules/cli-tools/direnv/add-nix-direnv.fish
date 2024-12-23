function add-nix-direnv --description "Add nix-direnv configuration to current folder" --argument-names lang 
    # Check that lang is provided
    if test -z $lang
        echo (set_color red)"Usage: add-nix-direnv <lang>"(set_color normal)
        return 1
    end

    # Check that .envrc doesn't already exist
    if test -e .envrc
        echo (set_color red)".envrc already exists. Aborting."(set_color normal)
        return 1
    end

    # Check that flake.nix doesn't already exist
    if test -e flake.nix
        echo (set_color red)"flake.nix already exists. Aborting."(set_color normal)
        return 1
    end

    set flakes_path "$HOME/flakes"

    # Write lang specific flake to .envrc
    switch $lang
        case bun
            cp "$flakes_path/bun/flake.nix" .

        case go
            cp "$flakes_path/go/flake.nix" .

        case python
            cp "$flakes_path/python/flake.nix" .

        case rust
            cp "$flakes_path/rust/flake.nix" .

        case scala
            cp "$flakes_path/scala/flake.nix" .

        case npm
            cp "$flakes_path/npm/flake.nix" .

        case '*'
            echo (set_color red)"Unknown language: $lang"(set_color normal)
            return 1
    end

    printf "use flake\ndotenv\n" >> .envrc

    # Add '.direnv' to .ignore file if it's not there already.
    if not test -e .gitignore; or grep --count "^\.direnv\$" .gitignore -eq 0
        echo '.direnv' >> .gitignore
    end

    # Add '.direnv' to .ignore file if it's not there already.
    if not test -e .ignore; or grep --count "^\.direnv\$" .ignore -eq 0
        echo '.direnv' >> .ignore
    end

    # Set permissions for created files to 664 (rw-rw-r--)
    # By default git doesn't track file permissions and defaults to 0644 (rw-r--r--)
    chmod 664 flake.nix .envrc .ignore

    echo (set_color green)"Added flake.nix, .envrc, and '.direnv' to .ignore."
    echo (set_color yellow)"Add flake.nix to git and run 'direnv allow' to load dev shell."(set_color normal)
end
