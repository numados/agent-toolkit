#!/usr/bin/env bash
set -euo pipefail

root_path=""
query=""
mode="auto"
limit=20
context=1
max_filesize="10M"
case_sensitive=false
include_hidden=false
include_vcs=false
allow_filesystem_root=false
globs=()
excludes=()

usage() {
  printf '%s\n' 'Usage: bounded-search.sh --root DIR --query TEXT [--mode auto|path|text|regex] [--glob GLOB] [--exclude GLOB] [--limit 1..100] [--context 0..3] [--max-filesize SIZE] [--case-sensitive] [--hidden] [--include-vcs] [--allow-filesystem-root]'
  printf '%s\n' 'Run bounded read-only filename and text search with ripgrep.'
  printf '%s\n' 'Example: bounded-search.sh --root ./repo --query RateProvider --glob "*.cs" --limit 10'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --root) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; root_path="$2"; shift 2;;
    --query) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; query="$2"; shift 2;;
    --mode) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; mode="$2"; shift 2;;
    --glob) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; globs+=("$2"); shift 2;;
    --exclude) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; excludes+=("$2"); shift 2;;
    --limit) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; limit="$2"; shift 2;;
    --context) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; context="$2"; shift 2;;
    --max-filesize) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; max_filesize="$2"; shift 2;;
    --case-sensitive) case_sensitive=true; shift;;
    --hidden) include_hidden=true; shift;;
    --include-vcs) include_vcs=true; shift;;
    --allow-filesystem-root) allow_filesystem_root=true; shift;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done

[ -n "$root_path" ] || { printf '%s\n' '--root is required.' >&2; exit 2; }
[ -n "$query" ] || { printf '%s\n' '--query is required.' >&2; exit 2; }
case "$root_path$query" in *$'\n'*|*$'\r'*) printf '%s\n' 'Root and query must be single-line values.' >&2; exit 2;; esac
case "$mode" in auto|path|text|regex) ;; *) printf 'Unsupported mode: %s\n' "$mode" >&2; exit 2;; esac
[[ "$limit" =~ ^[1-9][0-9]*$ ]] && [ "$limit" -le 100 ] || { printf '%s\n' '--limit must be between 1 and 100.' >&2; exit 2; }
[[ "$context" =~ ^[0-3]$ ]] || { printf '%s\n' '--context must be between 0 and 3.' >&2; exit 2; }
[[ "$max_filesize" =~ ^[1-9][0-9]*([KMG]|KiB|MiB|GiB)?$ ]] || { printf '%s\n' '--max-filesize must be a positive rg size such as 10M.' >&2; exit 2; }
[ -d "$root_path" ] || { printf 'Search root does not exist: %s\n' "$root_path" >&2; exit 3; }
root_path="$(cd "$root_path" && pwd -P)"
[ "$root_path" != / ] || [ "$allow_filesystem_root" = true ] || { printf '%s\n' 'Searching / requires --allow-filesystem-root.' >&2; exit 3; }
command -v rg >/dev/null 2>&1 || { printf '%s\n' 'ripgrep (rg) is unavailable; run numados-skill-doctor or use a verified harness/MCP provider.' >&2; exit 4; }
if [ "$mode" = regex ]; then
  set +e
  rg --regexp "$query" </dev/null >/dev/null 2>&1
  regex_status=$?
  set -e
  [ "$regex_status" -ne 2 ] || { printf 'Invalid regular expression: %s\n' "$query" >&2; exit 2; }
fi

case_args=()
[ "$case_sensitive" = true ] || case_args=(-i)
hidden_args=()
[ "$include_hidden" = false ] || hidden_args=(--hidden)
glob_args=()
if [ "$include_vcs" = false ]; then
  glob_args+=(-g '!.git/**' -g '!.hg/**' -g '!.svn/**')
fi
for glob in "${globs[@]}"; do
  case "$glob" in *$'\n'*|*$'\r'*) printf '%s\n' 'Globs must be single-line values.' >&2; exit 2;; esac
  glob_args+=(-g "$glob")
done
for exclude in "${excludes[@]}"; do
  case "$exclude" in *$'\n'*|*$'\r'*) printf '%s\n' 'Excludes must be single-line values.' >&2; exit 2;; esac
  glob_args+=(-g "!$exclude")
done

normalize_paths() {
  local path
  while IFS= read -r path; do
    printf '%s\n' "${path#./}"
  done
}

take_limit() {
  local count=0
  local line
  while IFS= read -r line; do
    printf '%s\n' "$line"
    count=$((count + 1))
    [ "$count" -lt "$limit" ] || break
  done
}

search_paths() {
  local match_args=(-F)
  [ "$mode" != regex ] || match_args=()
  { cd "$root_path" && rg --files "${hidden_args[@]}" "${glob_args[@]}" .; } |
    normalize_paths |
    rg "${case_args[@]}" "${match_args[@]}" -- "$query" |
    take_limit || true
}

search_content_files() {
  local match_args=(--fixed-strings)
  [ "$mode" != regex ] || match_args=()
  { cd "$root_path" && rg -l "${case_args[@]}" "${match_args[@]}" "${hidden_args[@]}" "${glob_args[@]}" --max-filesize "$max_filesize" -- "$query" .; } |
    normalize_paths |
    take_limit || true
}

show_snippets() {
  local relative_path
  local match_args=(--fixed-strings)
  [ "$mode" != regex ] || match_args=()
  while IFS= read -r relative_path; do
    [ -n "$relative_path" ] || continue
    { cd "$root_path" && rg -n --with-filename --max-count 2 -C "$context" "${case_args[@]}" "${match_args[@]}" -- "$query" "$relative_path"; } || true
  done
}

if [ "$mode" = auto ] || [ "$mode" = path ] || [ "$mode" = regex ]; then
  printf '%s\n' '[path_matches]'
  path_results="$(search_paths)"
  if [ -n "$path_results" ]; then printf '%s\n' "$path_results"; else printf '%s\n' '(none)'; fi
fi

if [ "$mode" = auto ] || [ "$mode" = text ] || [ "$mode" = regex ]; then
  printf '%s\n' '[content_matches]'
  content_files="$(search_content_files)"
  if [ -n "$content_files" ]; then printf '%s\n' "$content_files" | show_snippets; else printf '%s\n' '(none)'; fi
fi
