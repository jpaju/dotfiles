#!/usr/bin/env bash
set -euo pipefail

# Usage: gh-branch-info <owner/repo> <branch>
if [ $# -ne 2 ]; then
  echo "Usage: gh-branch-info <owner/repo> <branch>" >&2
  echo "Example: gh-branch-info cli/cli trunk" >&2
  exit 1
fi

REPO="$1"
BRANCH="$2"

if [[ ! "$REPO" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
  echo "Error: Invalid repo format. Expected: owner/repo" >&2
  exit 1
fi

OWNER="${REPO%/*}"
REPO_NAME="${REPO#*/}"
if [[ "$OWNER" == "." || "$OWNER" == ".." || "$REPO_NAME" == "." || "$REPO_NAME" == ".." ]]; then
  echo "Error: Invalid repo format. Expected: owner/repo" >&2
  exit 1
fi

if [[ ! "$BRANCH" =~ ^[a-zA-Z0-9._/-]+$ ]] || [[ "$BRANCH" == -* || "$BRANCH" == /* || "$BRANCH" == */ || "$BRANCH" == *..* ]]; then
  echo "Error: Invalid branch" >&2
  exit 1
fi

ENCODED_BRANCH="$(jq --null-input --raw-output --arg branch "$BRANCH" '$branch | @uri')"

exec gh api \
  --method GET \
  "repos/$REPO/branches/$ENCODED_BRANCH" \
  --jq '{name: .name, sha: .commit.sha, commitUrl: .commit.html_url, protected: .protected}'
