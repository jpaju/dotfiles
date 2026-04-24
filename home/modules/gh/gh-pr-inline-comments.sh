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

JQ_FILTER='
  . as $comments |
  ($comments | INDEX(.id)) as $all_comments |
  ($comments | map(select(.in_reply_to_id == null or ($all_comments[.in_reply_to_id | tostring] == null)))) as $parents |
  ($comments | map(select(.in_reply_to_id != null and ($all_comments[.in_reply_to_id | tostring] != null)))) as $replies |

  [
    $parents[] as $p | {
      id: $p.id,
      path: $p.path,
      line: $p.line,
      user: $p.user.login,
      body: $p.body,
      replies: [
        $replies[] | select(.in_reply_to_id == $p.id) | {
          user: .user.login,
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

if [ "$PENDING_ONLY" = true ]; then
  PENDING_REVIEW_ID="$({
    gh api "repos/$OWNER/$REPO_NAME/pulls/$PR_NUMBER/reviews" --jq 'map(select(.state == "PENDING"))[0].id // empty'
  })"

  if [ -z "$PENDING_REVIEW_ID" ]; then
    printf '[]\n'
    exit 0
  fi

  exec gh api "repos/$OWNER/$REPO_NAME/pulls/$PR_NUMBER/reviews/$PENDING_REVIEW_ID/comments" --jq "$JQ_FILTER"
fi

exec gh api "repos/$OWNER/$REPO_NAME/pulls/$PR_NUMBER/comments" --jq "$JQ_FILTER"
