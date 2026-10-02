function unset-prefix --argument-names prefix --description 'Unset exported variables by prefix'
    if test (count $argv) -ne 1; or test -z "$prefix"
        printf 'usage: unset-prefix <prefix>\n' >&2
        return 2
    end

    # Target only exported environment variables, not Fish's own variables
    for variable_name in (set --names --export)
        if test (string sub --length (string length -- "$prefix") -- "$variable_name") = "$prefix"
            set --erase -- "$variable_name"
        end
    end
end
