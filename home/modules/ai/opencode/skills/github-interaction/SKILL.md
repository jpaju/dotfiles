---
name: github-interaction
description: How to interact with GitHub. Load this skill whenever you need to interact with GitHub in any way.
---

# GitHub interaction

Use the `gh` CLI to interact with GitHub. It is already installed and authenticated.

Always prefer built-in `gh` subcommands (e.g. `gh pr view`, `gh pr list`) over `gh api`. The `gh api` command requires manual user approval for each invocation, so only use it when there is no built-in alternative.

## PR operations

### List PRs

```
gh pr list --state open --json number,title,url --limit 10
```

Returns a JSON array of PRs. Useful filters:

- `--state` — `open`, `closed`, `merged`, `all`
- `--author` — filter by author username
- `--limit` — number of results (default 30)
- `--json` — comma-separated list of fields to return

### View a PR

```
gh pr view 3731 --json comments,reviews,reviewRequests
```

Shows PR metadata, top-level comments, and review summaries. Supports `--json` with fields like `title`, `body`, `state`, `comments`, `reviews`, `reviewRequests`, `mergeable`, `reviewDecision`.

### Check PR workflow status

```
gh pr checks <number>
```

Quick summary of all checks (CI jobs, status checks). Only shows the latest run — see "Workflow runs" section to investigate previous or failed runs.

### Read top-level comments and reviews

```
gh pr view 3731 --json comments,reviews
```

Returns top-level PR comments and review-level comments (the summary each reviewer leaves when submitting a review).

**Note:** This does NOT return inline review comments (comments left on specific lines in the diff).

### Create a PR

```
gh pr create --title "..." --body "$(cat <<'EOF'
## Summary
...
EOF
)"
```

Do not specify `--base` — `gh` defaults to the repo's default branch. Only set `--base` explicitly when targeting a non-default branch (e.g. stacked diffs). If unclear, ask the user.

### Merge a PR

```
gh pr merge <number> --squash --delete-branch
```

Always squash merge (no merge commits). Always delete the branch after merge.

### Read inline review comments

```
gh-pr-inline-comments <owner/repo> <pr-number>
```

Returns inline/diff review comments grouped by file with author and line number.

## Workflow runs

### List workflow runs for a branch

```
gh run list --branch <branch-name> --json databaseId,status,conclusion,startedAt,name --limit 20
```

Returns all runs including failed and cancelled ones. Useful for finding previous failed runs.

- `--branch` — filter by branch name
- `--json` — useful fields: `databaseId`, `status`, `conclusion`, `startedAt`, `name`
- `--limit` — number of results

### View a workflow run

```
gh run view <run-id>
```

Shows jobs with status and duration, annotations, and artifacts. The run ID comes from `gh run list`.

### View logs for failed steps only

```
gh run view <run-id> --log-failed
```

Returns only the logs from failed steps. Pipe through `grep -i "FAILED"` to quickly locate failing tests.

### View full logs for a specific job

```
gh run view --job=<job-id> --log
```

The job ID is shown in the `gh run view` output. Use this when `--log-failed` doesn't give enough context.

## Issue search

### Search open issues

```
gh search issues --repo <owner/repo> "<keyword>" --limit 20
```

### Search closed issues

```
gh search issues --repo <owner/repo> "<keyword>" --state closed --limit 20
```

Useful filters:

- `--state` — `open`, `closed` (default: `open`)
- `--limit` — number of results (default 30)
- Combine multiple keywords in the query string for narrower results

## Discussion search

GitHub CLI has no built-in discussion search. Use the `gh-discussion-search` wrapper (uses GraphQL under the hood):

```
gh-discussion-search <owner/repo> "<keyword>"
gh-discussion-search <owner/repo> "<keyword>" 50  # custom limit, max 100
```

Returns: number, title, URL, category, isAnswered, createdAt.

## Gotchas

- `--json` field names are camelCase (e.g. `reviewDecision`, `reviewRequests`, not `review_decision`)
