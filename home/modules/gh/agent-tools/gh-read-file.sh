#!/usr/bin/env bash
set -euo pipefail

# Usage: gh-read-file <owner/repo> <path> [ref]
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: gh-read-file <owner/repo> <path> [ref]" >&2
  echo "Example: gh-read-file cli/cli docs/install_linux.md trunk" >&2
  exit 1
fi

REPO="$1"
FILE_PATH="$2"
REF="${3:-}"

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

if [[ ! "$FILE_PATH" =~ ^[a-zA-Z0-9._/@+-]+$ ]] ||
  [[ "$FILE_PATH" == /* || "$FILE_PATH" == */ || "/$FILE_PATH/" == *"//"* || "/$FILE_PATH/" == *"/./"* || "/$FILE_PATH/" == *"/../"* ]]; then
  echo "Error: Invalid file path" >&2
  exit 1
fi

if [ -n "$REF" ] && { [[ ! "$REF" =~ ^[a-zA-Z0-9._/-]+$ ]] || [[ "$REF" == /* || "$REF" == */ || "$REF" == *..* ]]; }; then
  echo "Error: Invalid ref" >&2
  exit 1
fi

ARGS=(
  --method GET
  "repos/$REPO/contents/$FILE_PATH"
  --header "Accept: application/vnd.github.raw+json"
)

if [ -n "$REF" ]; then
  ARGS+=(--raw-field "ref=$REF")
fi

exec gh api "${ARGS[@]}"
