#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: nix-inspect <eval|build> <installable>" >&2
  exit 1
}

if [ "$#" -ne 2 ]; then
  usage
fi

case "$1" in
eval)
  exec nix eval --read-only --no-write-lock-file -- "$2"
  ;;
build)
  exec nix build --no-link --print-out-paths -- "$2"
  ;;
*)
  usage
  ;;
esac
