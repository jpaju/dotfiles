#!/usr/bin/env bash
set -euo pipefail

pid=""

cleanup() {
  if [[ -n "$pid" ]]; then
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  fi
}
trap cleanup EXIT

(trap - INT; exec aioesphomeapi-discover "$@") &
pid=$!

sleep 2
kill -INT "$pid" 2>/dev/null || true

status=0
wait "$pid" || status=$?
pid=""
exit "$status"
