#!/usr/bin/env bash

set -e

find_d_toml() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    [ -f "$dir/d.toml" ] && echo "$dir/d.toml" && return
    dir=$(dirname "$dir")
  done
  echo "d.toml not found" >&2
  exit 1
}

declare -A CMD
DEFAULT_CMD=""

parse_toml() {
  local section=""
  while IFS='=' read -r k v; do
    k=$(echo "$k" | xargs)
    v=$(echo "$v" | xargs | sed 's/^"//;s/"$//')
    [[ "$k" =~ ^#.*$ || -z "$k" ]] && continue
    [[ "$k" == \[* ]] && section="${k#[}" && section="${section%]}" && continue

    case "$section" in
      commands) CMD["$k"]="$v" ;;
      default) [ "$k" = "command" ] && DEFAULT_CMD="$v" ;;
    esac
  done < "$1"
}

# --- Main ---
config_file=$(find_d_toml) || exit 1
parse_toml $config_file || exit 1

if [[ -z "$1" ]]; then
  echo "Usage:"
  echo "  $(basename "$0") <command> [args...]"
  echo "For default command if defined:"
  echo "  $(basename "$0") [args...]"
  echo
  echo "Available commands:"
  for k in "${!CMD[@]}"; do
    printf "  %-15s -> %s\n" "$k" "${CMD[$k]}"
  done
  [ -n "$DEFAULT_CMD" ] && printf "  %-15s -> %s\n" "(default)" "${DEFAULT_CMD}"
  exit 0
fi

cmd="$1"
shift

if [[ -n "${CMD[$cmd]}" ]]; then
  if [[ $# -eq 0 ]]; then
    COMMAND="${CMD[$cmd]}" 
  else
    COMMAND="${CMD[$cmd]} $(printf '%q ' "$@")"
  fi
  bash -c "${COMMAND}"
elif [[ -n "$DEFAULT_CMD" ]]; then
  if [[ $# -eq 0 ]]; then
    COMMAND="${DEFAULT_CMD} ${cmd}"
  else
    COMMAND="${DEFAULT_CMD} ${cmd} $(printf '%q ' "$@")"
  fi
  bash -c "${COMMAND}"
else
  echo "Unknown command: $cmd" >&2
  exit 1
fi
