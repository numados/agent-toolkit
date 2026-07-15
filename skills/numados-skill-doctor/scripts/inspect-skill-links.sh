#!/usr/bin/env bash
set -euo pipefail

root=""
link_dirs=()

usage() {
  printf '%s\n' 'Usage: inspect-skill-links.sh --root DIR [--link-dir DIR ...]'
  printf '%s\n' 'Verify every toolkit skill is symlinked into each harness skills directory.'
  printf '%s\n' 'Default link dirs: ~/.claude/skills (Claude Code) and ~/.agents/skills (Codex CLI, pi).'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --root) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; root="$2"; shift 2;;
    --link-dir) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; link_dirs+=("$2"); shift 2;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done

[ -n "$root" ] || { printf '%s\n' '--root is required.' >&2; exit 2; }
[ -d "$root" ] || { printf 'Toolkit root does not exist: %s\n' "$root" >&2; exit 2; }
root="$(cd "$root" && pwd -P)"

skills_root="$root/skills"
[ -d "$skills_root" ] || skills_root="$root"

if [ "${#link_dirs[@]}" -eq 0 ]; then
  link_dirs=("$HOME/.claude/skills" "$HOME/.agents/skills")
fi

status=0
found=0

for skill_dir in "$skills_root"/*/; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  found=1
  skill_name="$(basename "$skill_dir")"
  skill_path="$(cd "$skill_dir" && pwd -P)"

  for link_dir in "${link_dirs[@]}"; do
    entry="$link_dir/$skill_name"
    if [ ! -e "$entry" ] && [ ! -L "$entry" ]; then
      printf 'MISSING %s: no entry in %s\n' "$skill_name" "$link_dir"
      status=1
      continue
    fi
    if [ ! -L "$entry" ]; then
      printf 'COPY %s: %s is a real directory, not a symlink to the toolkit\n' "$skill_name" "$entry"
      status=1
      continue
    fi
    resolved="$(cd "$entry" 2>/dev/null && pwd -P || true)"
    if [ -z "$resolved" ]; then
      printf 'BROKEN %s: %s -> %s (target missing)\n' "$skill_name" "$entry" "$(readlink "$entry")"
      status=1
      continue
    fi
    if [ "$resolved" != "$skill_path" ]; then
      printf 'STALE %s: %s resolves to %s, expected %s\n' "$skill_name" "$entry" "$resolved" "$skill_path"
      status=1
      continue
    fi
    printf 'OK %s: %s\n' "$skill_name" "$entry"
  done
done

if [ "$found" -eq 0 ]; then
  printf 'No skills found under %s\n' "$skills_root" >&2
  exit 2
fi

exit "$status"
