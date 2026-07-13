#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd -P)"
source "$script_dir/_context.sh"

vault_path=""
config_path=""
profile=""
start_dir="$PWD"
show_context=false

usage() {
  printf '%s\n' 'Usage: resolve-vault.sh [--vault PATH] [--config FILE|--profile NAME] [--start-dir DIR] [--show-context]'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --vault)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      vault_path="$2"
      shift 2
      ;;
    --config)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      config_path="$2"
      shift 2
      ;;
    --profile)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      profile="$2"
      shift 2
      ;;
    --start-dir)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      start_dir="$2"
      shift 2
      ;;
    --show-context)
      show_context=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

[ -d "$start_dir" ] || { printf 'Start directory does not exist: %s\n' "$start_dir" >&2; exit 2; }
numados_resolve_context "$vault_path" "$config_path" "$profile" "$start_dir"

if [ "$show_context" = true ]; then
  printf 'vault: %s\n' "$NUMADOS_RESOLVED_VAULT"
  printf 'source: %s\n' "$NUMADOS_RESOLVED_SOURCE"
  printf 'profile: %s\n' "${NUMADOS_RESOLVED_PROFILE:-(none)}"
  printf 'config: %s\n' "${NUMADOS_RESOLVED_CONFIG:-(none)}"
  printf 'project_marker: %s\n' "${NUMADOS_RESOLVED_MARKER:-(none)}"
else
  printf '%s\n' "$NUMADOS_RESOLVED_VAULT"
fi
