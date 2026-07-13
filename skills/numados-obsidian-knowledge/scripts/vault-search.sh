#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd -P)"
query=""
mode="auto"
scope=""
limit=12
context=1
case_sensitive=false
resolve_args=()

usage() {
  printf '%s\n' 'Usage: vault-search.sh --query TEXT [--mode auto|path|text|regex] [--scope RELATIVE_DIR] [--limit N] [--context N] [--case-sensitive] [--vault PATH|--config FILE|--profile NAME] [--start-dir DIR]'
  printf '%s\n' 'Search Markdown paths and content with bounded ripgrep output; requires rg.'
  printf '%s\n' 'Example: vault-search.sh --profile work --query "rate limit" --limit 10'
}

is_positive_integer() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --query)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      query="$2"
      shift 2
      ;;
    --mode)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      mode="$2"
      shift 2
      ;;
    --scope)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      scope="$2"
      shift 2
      ;;
    --limit)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      limit="$2"
      shift 2
      ;;
    --context)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      context="$2"
      shift 2
      ;;
    --case-sensitive)
      case_sensitive=true
      shift
      ;;
    --vault|--config|--profile|--start-dir)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      resolve_args+=("$1" "$2")
      shift 2
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

[ -n "$query" ] || { printf '%s\n' 'Search query is required.' >&2; exit 2; }
case "$mode" in auto|path|text|regex) ;; *) printf 'Unsupported mode: %s\n' "$mode" >&2; exit 2;; esac
is_positive_integer "$limit" || { printf '%s\n' '--limit must be a positive integer.' >&2; exit 2; }
[[ "$context" =~ ^[0-3]$ ]] || { printf '%s\n' '--context must be between 0 and 3.' >&2; exit 2; }
command -v rg >/dev/null 2>&1 || {
  printf '%s\n' 'ripgrep (rg) is unavailable. Use a verified harness/MCP filesystem-search provider or run numados-skill-doctor for setup recommendations.' >&2
  exit 4
}

vault_path="$("$script_dir/resolve-vault.sh" "${resolve_args[@]}")"
search_root="$vault_path"

if [ -n "$scope" ]; then
  case "$scope" in *$'\n'*|*$'\r'*) printf '%s\n' 'Scope must be a single-line path.' >&2; exit 2;; esac
  case "/$scope/" in
    /*/../*|/*/./*) printf 'Scope must be a clean vault-relative directory: %s\n' "$scope" >&2; exit 2;;
  esac
  case "$scope" in /*) printf 'Scope must be relative to the vault: %s\n' "$scope" >&2; exit 2;; esac
  [ -d "$vault_path/$scope" ] || { printf 'Scope does not exist: %s\n' "$scope" >&2; exit 3; }
  search_root="$(cd "$vault_path/$scope" && pwd -P)"
  case "$search_root/" in "$vault_path/"*) ;; *) printf '%s\n' 'Scope resolves outside the vault.' >&2; exit 3;; esac
fi

case_args=()
if [ "$case_sensitive" = false ]; then
  case_args=(-i)
fi

to_relative_paths() {
  local path
  while IFS= read -r path; do
    case "$path" in
      "$vault_path/"*) printf '%s\n' "${path#"$vault_path/"}" ;;
      *) printf '%s\n' "$path" ;;
    esac
  done
}

search_paths() {
  local match_args=(-F)
  if [ "$mode" = regex ]; then
    match_args=()
  fi
  rg --files "$search_root" -g '*.md' | to_relative_paths | rg "${case_args[@]}" "${match_args[@]}" -- "$query" | sed -n "1,${limit}p;${limit}q" || true
}

search_content_files() {
  local match_args=(--fixed-strings)
  if [ "$mode" = regex ]; then
    match_args=()
  fi
  rg -l "${case_args[@]}" "${match_args[@]}" -g '*.md' -- "$query" "$search_root" | to_relative_paths | sed -n "1,${limit}p;${limit}q" || true
}

show_snippets() {
  local relative_path
  local match_args=(--fixed-strings)
  if [ "$mode" = regex ]; then
    match_args=()
  fi

  while IFS= read -r relative_path; do
    [ -n "$relative_path" ] || continue
    rg -n --with-filename --max-count 2 -C "$context" "${case_args[@]}" "${match_args[@]}" -- "$query" "$vault_path/$relative_path" | to_relative_paths || true
  done
}

if [ "$mode" = auto ] || [ "$mode" = path ] || [ "$mode" = regex ]; then
  printf '%s\n' '[path_matches]'
  path_results="$(search_paths)"
  if [ -n "$path_results" ]; then
    printf '%s\n' "$path_results"
  else
    printf '%s\n' '(none)'
  fi
fi

if [ "$mode" = auto ] || [ "$mode" = text ] || [ "$mode" = regex ]; then
  printf '%s\n' '[content_matches]'
  content_files="$(search_content_files)"
  if [ -n "$content_files" ]; then
    printf '%s\n' "$content_files" | show_snippets
  else
    printf '%s\n' '(none)'
  fi
fi
