#!/usr/bin/env bash
set -euo pipefail

# Usage: gh-pr-inline-comments [--pending] <owner/repo> <pr-number>
PENDING_ONLY=false

if [ $# -gt 0 ] && [ "$1" = "--pending" ]; then
  PENDING_ONLY=true
  shift
fi

if [ $# -ne 2 ]; then
  echo "Usage: gh-pr-inline-comments [--pending] <owner/repo> <pr-number>" >&2
  echo "Example: gh-pr-inline-comments my-org/my-repo 42" >&2
  echo "         gh-pr-inline-comments --pending my-org/my-repo 42" >&2
  exit 1
fi

REPO="$1"
PR_NUMBER="$2"

if [[ ! "$REPO" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
  echo "Error: Invalid repo format. Expected: owner/repo" >&2
  exit 1
fi

if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]] || [ "$PR_NUMBER" -lt 1 ]; then
  echo "Error: PR number must be a positive integer" >&2
  exit 1
fi

OWNER="${REPO%/*}"
REPO_NAME="${REPO#*/}"

if [ "$PENDING_ONLY" = true ]; then
  COMMENT_SELECTOR='select(.pullRequestReview.state == "PENDING")'
else
  COMMENT_SELECTOR='select(.pullRequestReview.state != "PENDING")'
fi

GRAPHQL_QUERY='
  query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
    repository(owner: $owner, name: $name) {
      pullRequest(number: $number) {
        reviewThreads(first: 100, after: $endCursor) {
          nodes {
            isResolved
            comments(first: 100) {
              nodes {
                databaseId
                path
                line
                author { login }
                body
                pullRequestReview { state }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    }
  }
'

JQ_FILTER='
  [
    .[].data.repository.pullRequest.reviewThreads.nodes[] |
    . as $thread |
    ([.comments.nodes[] | __COMMENT_SELECTOR__]) as $comments |
    select($comments | length > 0) |
    $comments[0] as $p | {
      id: $p.databaseId,
      path: $p.path,
      line: $p.line,
      user: $p.author.login,
      body: $p.body,
      isResolved: $thread.isResolved,
      replies: [
        $comments[1:][] | {
          user: .author.login,
          body: .body
        }
      ]
    }
  ] |

  group_by(.path) | map({
    path: .[0].path,
    comments: map(del(.path))
  })
'

JQ_FILTER="${JQ_FILTER/__COMMENT_SELECTOR__/$COMMENT_SELECTOR}"

gh api graphql \
  --paginate \
  --slurp \
  -f owner="$OWNER" \
  -f name="$REPO_NAME" \
  -F number="$PR_NUMBER" \
  -f query="$GRAPHQL_QUERY" |
  jq "$JQ_FILTER"
