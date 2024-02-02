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

    set flakes_path "$HOME/.config/nix/flakes"

    # Write lang specific flake to .envrc
    switch $lang
        case bun
            echo "use flake path:$flakes_path/bun" >> .envrc

        case python py
            echo "use flake path:$flakes_path/python" >> .envrc

        case rust rs
            echo "use flake path:$flakes_path/rust" >> .envrc

        case scala sc
            echo "use flake github:devinsideyou/scala-seed#java17" >> .envrc

        case typescript ts
            echo "use flake path:$flakes_path/typescript" >> .envrc

        case '*'
            echo (set_color red)"Unknown language: $lang"(set_color normal)
            return 1
    end

    # Add '.direnv' to .ignore file if it's not there already.
    if not test -e .ignore; or grep --count "^\.direnv\$" .ignore -eq 0
        echo '.direnv' >> .ignore
    end

    echo (set_color green)"Added .envrc file, and added .direnv to .ignore."
    echo "Run 'direnv allow' to apply changes."(set_color normal)
end
