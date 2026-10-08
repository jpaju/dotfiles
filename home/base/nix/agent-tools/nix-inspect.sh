#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: nix-inspect eval [--raw|--json] [--apply FUNCTION] [--impure] [--no-write-lock-file] <installable|--expr EXPR|--file PATH>" >&2
  echo "       nix-inspect build <installable>" >&2
  exit 1
}

[ "$#" -gt 0 ] || usage

operation=$1
shift

if [ "$operation" = build ]; then
  [ "$#" -eq 1 ] || usage
  exec nix build --no-link --print-out-paths -- "$1"
fi

[ "$operation" = eval ] || usage

options=()
operands=()
input_mode=
output_mode=
has_apply=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --raw|--json)
      [ -z "$output_mode" ] || usage
      output_mode=$1
      options+=("$1")
      shift
      ;;

    --apply|--expr|--file)
      [ "$#" -ge 2 ] || usage
      case "$2" in
        --*)
          usage
          ;;
      esac
      if [ "$1" = --apply ]; then
        [ "$has_apply" = false ] || usage
        has_apply=true
      else
        [ -z "$input_mode" ] || usage
        input_mode=$1
        if [ "$1" = --file ] && [ "$2" = - ]; then
          usage
        fi
      fi
      options+=("$1" "$2")
      shift 2
      ;;

    --impure)
      options+=("$1")
      shift
      ;;

    --no-write-lock-file)
      shift
      ;;

    --)
      shift
      while [ "$#" -gt 0 ]; do
        [ -z "$input_mode" ] || usage
        input_mode=installable
        operands+=("$1")
        shift
      done
      ;;

    -*)
      usage
      ;;

    *)
      [ -z "$input_mode" ] || usage
      input_mode=installable
      operands+=("$1")
      shift
      ;;
  esac
done

if [ -z "$input_mode" ]; then
  usage
fi

exec nix eval \
  --read-only \
  --no-write-lock-file \
  --option allow-import-from-derivation false \
  --option allow-unsafe-native-code-during-evaluation false \
  ${options[@]+"${options[@]}"} \
  -- ${operands[@]+"${operands[@]}"}
