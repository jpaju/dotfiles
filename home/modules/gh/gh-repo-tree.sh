#!/usr/bin/env bash
set -euo pipefail

# Usage: gh-repo-tree <owner/repo> [ref]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: gh-repo-tree <owner/repo> [ref]" >&2
  echo "Example: gh-repo-tree cli/cli trunk" >&2
  exit 1
fi

REPO="$1"
REF="${2:-}"

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

if [ -n "$REF" ] && { [[ ! "$REF" =~ ^[a-zA-Z0-9._/-]+$ ]] || [[ "$REF" == -* || "$REF" == /* || "$REF" == */ || "$REF" == *..* ]]; }; then
  echo "Error: Invalid ref" >&2
  exit 1
fi

COMMIT_ARGS=(
  --method GET
  "repos/$REPO/commits"
  --raw-field "per_page=1"
  --jq '.[0].commit.tree.sha // empty'
)

if [ -n "$REF" ]; then
  COMMIT_ARGS+=(--raw-field "sha=$REF")
fi

TREE_SHA="$(gh api "${COMMIT_ARGS[@]}")"

if [ -z "$TREE_SHA" ]; then
  echo "Error: Ref not found" >&2
  exit 1
fi

exec gh api \
  --method GET \
  "repos/$REPO/git/trees/$TREE_SHA" \
  --raw-field "recursive=1" \
  --jq 'if .truncated then error("Recursive tree is truncated") else .tree[].path end'
