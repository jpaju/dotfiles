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

function __gh_list_repos
    gh api graphql --paginate \
        -f query='query($endCursor: String) { viewer { repositories(first: 100, after: $endCursor) { nodes { nameWithOwner } pageInfo { hasNextPage endCursor } } } }' \
        -q '.data.viewer.repositories.nodes[].nameWithOwner' 2>/dev/null
end

complete -c gh -f -n __gh_repo_clone_before_dashdash -a '(__gh_list_repos)'
complete -c gh -f -n __gh_repo_clone_after_dashdash -a "$git_clone_flags"
