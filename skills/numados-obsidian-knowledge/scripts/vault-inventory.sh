#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd -P)"

for argument in "$@"; do
  case "$argument" in
    --help|-h)
      printf '%s\n' 'Usage: vault-inventory.sh [--vault PATH] [--config FILE|--profile NAME] [--start-dir DIR]'
      exit 0
      ;;
  esac
done

resolved_context="$("$script_dir/resolve-vault.sh" "$@" --show-context)"
vault_path="$(printf '%s\n' "$resolved_context" | awk -F': ' '$1 == "vault" { print substr($0, index($0, ": ") + 2); exit }')"

count_matches() {
  local mode="$1"
  local pattern="$2"
  local result

  if [ "$mode" = files ]; then
    result="$({ rg --files "$vault_path" -g "$pattern" || true; } | wc -l | tr -d ' ')"
  else
    result="$({ rg "$mode" "$pattern" "$vault_path" -g '*.md' 2>/dev/null || true; } | wc -l | tr -d ' ')"
  fi
  printf '%s' "$result"
}

printf '%s\n' "$resolved_context"
printf 'size: %s\n' "$(du -sh "$vault_path" | cut -f1)"
printf 'markdown_files: %s\n' "$(count_matches files '*.md')"
printf 'frontmatter_files: %s\n' "$(count_matches -l '^---$')"
printf 'wikilinks: %s\n' "$(count_matches -o '\[\[[^]]+\]\]')"
printf 'filesystem_search: available\n'

if command -v obsidian >/dev/null 2>&1; then
  printf 'obsidian_cli: available\n'
else
  printf 'obsidian_cli: unavailable\n'
fi

if command -v qmd >/dev/null 2>&1; then
  printf 'qmd: available\n'
else
  printf 'qmd: unavailable\n'
fi

if command -v git >/dev/null 2>&1 && git -C "$vault_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf 'git_history: available\n'
else
  printf 'git_history: unavailable\n'
fi

printf '%s\n' 'top_level_directories:'
find "$vault_path" -mindepth 1 -maxdepth 1 -type d ! -name '.obsidian' ! -name '.git' -printf '%f\n' | sort
