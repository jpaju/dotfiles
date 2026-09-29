# Adapted for fish from Chris K.Y. Fung's bash completion script:
#   https://chriskyfung.github.io/blog/devtools/github-cli-repo-clone-custom-completion/
#
# Augment gh's native fish completion with smart `gh repo clone` suggestions.
# Load native gh completion first so we don't shadow it (fish only loads the
# first completions/gh.fish found in $fish_complete_path).
gh completion --shell fish | source

set -l git_clone_flags \
    --also-filter-submodules --bare --branch= --depth= --filter= \
    --no-checkout --quiet --recurse-submodules --shallow-since= \
    --single-branch --sparse --tags --verbose

function __gh_repo_clone_in_progress
    __fish_seen_subcommand_from repo
    and __fish_seen_subcommand_from clone
end

function __gh_repo_clone_after_dashdash
    __gh_repo_clone_in_progress
    and contains -- -- (commandline -opc)
end

function __gh_repo_clone_before_dashdash
    __gh_repo_clone_in_progress
    and not contains -- -- (commandline -opc)
end

function __gh_repo_clone_candidates
    set -l token (commandline -ct)

    if string match -q -- '-*' $token
        return
    end

    # Scope repo lookup to the typed owner so large organizations stay responsive.
    if string match -q -- '*/*' $token
        set -l parts (string split -m1 / -- $token)
        set -l owner $parts[1]
        set -l repo $parts[2]

        if test -n "$owner"
            set -l repos
            # Search by name once the prefix is selective; use a bounded list before that.
            if test (string length -- "$repo") -ge 3
                set repos (gh search repos "$repo" --owner "$owner" --match name \
                    --limit 100 --json fullName --jq '.[].fullName' 2>/dev/null)
            else
                set repos (gh repo list "$owner" --limit 100 --json nameWithOwner \
                    --jq '.[].nameWithOwner' 2>/dev/null)
            end

            # Fish's fuzzy matching otherwise offers unrelated repos when none match the prefix.
            string match -i -- "$token*" $repos
        end
    else
        # Suggest known owners immediately; public owners need a typed prefix to search.
        gh auth status --active --hostname github.com --json hosts \
            --jq '.hosts["github.com"][] | select(.active) | .login' 2>/dev/null | string replace -r '$' '/'

        gh org list --limit 100 2>/dev/null | string replace -r '$' '/'

        # Search public logins only after three characters to avoid broad requests on Tab.
        if test (string length -- "$token") -ge 3
            gh api -X GET search/users -f q="$token in:login" -f per_page=20 \
                --jq '.items[].login' 2>/dev/null | string replace -r '$' '/'
        end
    end
end

complete -c gh -f -n __gh_repo_clone_before_dashdash -a '(__gh_repo_clone_candidates)'
complete -c gh -f -n __gh_repo_clone_after_dashdash -a "$git_clone_flags"
