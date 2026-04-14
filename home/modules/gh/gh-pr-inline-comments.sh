#!/usr/bin/env bash
set -euo pipefail

# Usage: gh-pr-inline-comments <owner/repo> <pr-number>
if [ $# -ne 2 ]; then
  echo "Usage: gh-pr-inline-comments <owner/repo> <pr-number>" >&2
  echo "Example: gh-pr-inline-comments my-org/my-repo 42" >&2
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

exec gh api "repos/$OWNER/$REPO_NAME/pulls/$PR_NUMBER/comments" --jq '
  (map(select(.in_reply_to_id == null)) | INDEX(.id)) as $parents |
  (map(select(.in_reply_to_id != null))) as $replies |

  [
    $parents | to_entries[] | .value as $p | {
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
