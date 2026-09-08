#!/usr/bin/env bash
set -euo pipefail

# Usage: gh-discussion-search <owner/repo> <keyword> [limit]
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: gh-discussion-search <owner/repo> <keyword> [limit]" >&2
  echo "Example: gh-discussion-search home-assistant/core zigbee" >&2
  echo "         gh-discussion-search home-assistant/core zigbee 50" >&2
  exit 1
fi

REPO="$1"
KEYWORD="$2"
LIMIT="${3:-20}"

# Validate repo format (owner/repo)
if [[ ! "$REPO" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
  echo "Error: Invalid repo format. Expected: owner/repo" >&2
  exit 1
fi

# Cap keyword length to prevent abuse
if [ ${#KEYWORD} -gt 200 ]; then
  echo "Error: Keyword too long (max 200 chars)" >&2
  exit 1
fi

# Validate limit is a number and within range (1-100, GraphQL API max is 100)
if ! [[ "$LIMIT" =~ ^[0-9]+$ ]] || [ "$LIMIT" -lt 1 ] || [ "$LIMIT" -gt 100 ]; then
  echo "Error: Limit must be a number between 1 and 100" >&2
  exit 1
fi

# Execute read-only GraphQL query
exec gh api graphql -f query="
  query {
    search(query: \"repo:$REPO $KEYWORD\", type: DISCUSSION, first: $LIMIT) {
      discussionCount
      nodes {
        ... on Discussion {
          number
          title
          url
          category { name }
          isAnswered
          createdAt
        }
      }
    }
  }
"
