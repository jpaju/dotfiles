---
name: git
description: Load when interacting with Git
---

# Git

## Commit messages

Default format: `<scope>: <summary>`

- Scope: the area the change touches, lowercase. A module, feature, or kind of work (e.g. `tests`, `docs`, `review`)
- Summary: lowercase, imperative, no trailing period, short
- Check recent commits in the repository and match their style
- Add a body only when something needs explaining

Examples:

- `checkout: prevent duplicate order submission`
- `search: ignore case in exact matches`
- `tests: cover ordering guarantee of batch publishing`
- `docs: replace legacy logging links`
- `ci: use Java 25 for native assembly`
- `review: use scale-insensitive equals`

## Branch names

Default format: `jpaju/<kebab-case-description>`

- Describe the goal of the change, not the technical steps taken to reach it
- Keep it short. Domain abbreviations are fine
- Number stacked PRs with a suffix: `-1`, `-2`, ...

Examples:

| Technical                            | Goal                                   |
| ------------------------------------ | -------------------------------------- |
| `jpaju/gradle-dependency-caching`    | `jpaju/reduce-ci-rate-limit-failures`  |
| `jpaju/fix-immediate-entity-updater` | `jpaju/preserve-unrelated-offer-edits` |
| `jpaju/outbox-tracing`               | `jpaju/diagnose-outbox-slowdown`       |
| `jpaju/revert-live-config-update`    | `jpaju/restore-prod-deployments`       |

## Avoid

- Ticket references in commit messages and branch names
- Mentioning commit hashes in responses, unless the user asks for them
- Creating new worktrees, unless the user asks for them
