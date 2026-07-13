#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd -P)"
source "$script_dir/_context.sh"

vault_path=""
config_path=""
profile=""
start_dir="$PWD"

usage() {
  printf '%s\n' 'Usage: validate-vault-context.sh [--vault PATH] [--config FILE|--profile NAME] [--start-dir DIR]'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --vault) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; vault_path="$2"; shift 2;;
    --config) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; config_path="$2"; shift 2;;
    --profile) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; profile="$2"; shift 2;;
    --start-dir) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; start_dir="$2"; shift 2;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done

[ -d "$start_dir" ] || { printf 'Start directory does not exist: %s\n' "$start_dir" >&2; exit 2; }
numados_resolve_context "$vault_path" "$config_path" "$profile" "$start_dir"
vault_path="$NUMADOS_RESOLVED_VAULT"

validate_relative_dir() {
  local label="$1"
  local root="$2"
  [ -n "$root" ] || return 0

  case "/$root/" in /*/../*|/*/./*) printf '%s must be a clean relative path: %s\n' "$label" "$root" >&2; return 1;; esac
  case "$root" in /*) printf '%s must be vault-relative: %s\n' "$label" "$root" >&2; return 1;; esac
  [ -d "$vault_path/$root" ] || { printf '%s does not exist: %s\n' "$label" "$root" >&2; return 1; }
  printf '%s: %s\n' "$label" "$root"
}

printf 'vault: %s\n' "$vault_path"
printf 'source: %s\n' "$NUMADOS_RESOLVED_SOURCE"
printf 'profile: %s\n' "${NUMADOS_RESOLVED_PROFILE:-(none)}"

write_root="$(numados_context_value NUMADOS_OBSIDIAN_WRITE_ROOT)"
search_roots="$(numados_context_value NUMADOS_OBSIDIAN_SEARCH_ROOTS)"
backend="$(numados_context_value NUMADOS_OBSIDIAN_SEARCH_BACKEND)"
qmd_collection="$(numados_context_value NUMADOS_OBSIDIAN_QMD_COLLECTION)"
link_style="$(numados_context_value NUMADOS_OBSIDIAN_LINK_STYLE)"

validate_relative_dir write_root "$write_root"

if [ -n "$search_roots" ]; then
  IFS=',' read -r -a root_list <<< "$search_roots"
  for root in "${root_list[@]}"; do
    validate_relative_dir search_root "$root"
  done
fi

backend="${backend:-auto}"
case "$backend" in
  auto|filesystem) ;;
  obsidian) command -v obsidian >/dev/null 2>&1 || { printf '%s\n' 'Configured backend obsidian is unavailable.' >&2; exit 4; } ;;
  qmd)
    command -v qmd >/dev/null 2>&1 || { printf '%s\n' 'Configured backend qmd is unavailable.' >&2; exit 4; }
    [ -n "$qmd_collection" ] || { printf '%s\n' 'NUMADOS_OBSIDIAN_QMD_COLLECTION is required for qmd.' >&2; exit 4; }
    ;;
  *) printf 'Unsupported search backend: %s\n' "$backend" >&2; exit 4;;
esac

link_style="${link_style:-preserve}"
case "$link_style" in preserve|wikilink|markdown) ;; *) printf 'Unsupported link style: %s\n' "$link_style" >&2; exit 4;; esac

printf 'search_backend: %s\n' "$backend"
printf 'link_style: %s\n' "$link_style"
printf '%s\n' 'Vault context is valid.'
