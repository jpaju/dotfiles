#!/usr/bin/env bash
set -euo pipefail

# Usage: gh-ref-sha <owner/repo> [ref]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: gh-ref-sha <owner/repo> [ref]" >&2
  echo "Example: gh-ref-sha cli/cli trunk" >&2
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

ARGS=(
  --method GET
  "repos/$REPO/commits"
  --raw-field "per_page=1"
  --jq '.[0].sha // empty'
)

if [ -n "$REF" ]; then
  ARGS+=(--raw-field "sha=$REF")
fi

SHA="$(gh api "${ARGS[@]}")"

if [ -z "$SHA" ]; then
  echo "Error: Ref not found" >&2
  exit 1
fi

printf '%s\n' "$SHA"
