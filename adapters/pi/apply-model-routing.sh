#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd -P)"
pi_dir="${PI_CODING_AGENT_DIR:-${HOME:?}/.pi/agent}"
dry_run=0

if [ "${1:-}" = "--dry-run" ]; then
    dry_run=1
elif [ "$#" -gt 0 ]; then
    printf 'Usage: %s [--dry-run]\n' "$0" >&2
    exit 2
fi

source_root="$repo_root/adapters/pi"
managed_files=(
    "skills/model-router/SKILL.md"
    "agents/scout.md"
    "agents/planner.md"
    "agents/reviewer.md"
    "agents/worker.md"
    "agents/codex-worker.md"
    "agents/worker-glm.md"
    "agents/teams.md"
)

if [ "$dry_run" -eq 1 ]; then
    printf 'Pi target: %s\n' "$pi_dir"
    printf 'Would merge: %s\n' "$pi_dir/settings.json"
    for relative_path in "${managed_files[@]}"; do
        printf 'Would install: %s\n' "$pi_dir/$relative_path"
    done
    exit 0
fi

for relative_path in "${managed_files[@]}"; do
    if [ ! -f "$source_root/$relative_path" ]; then
        printf 'Missing adapter source: %s\n' "$source_root/$relative_path" >&2
        exit 1
    fi
done
if [ ! -f "$source_root/settings.overlay.json" ]; then
    printf 'Missing adapter source: %s\n' "$source_root/settings.overlay.json" >&2
    exit 1
fi

backup_root="${NUMADOS_PI_BACKUP_DIR:-$HOME/.local/state/numados/pi-backups/$(date -u +%Y%m%dT%H%M%SZ)}"
mkdir -p "$pi_dir" "$backup_root"

backup_if_present() {
    local target="$1"
    local relative_path="$2"
    if [ -L "$target" ]; then
        printf 'Refusing to overwrite symlink: %s\n' "$target" >&2
        exit 1
    fi
    if [ -f "$target" ]; then
        mkdir -p "$backup_root/$(dirname "$relative_path")"
        cp -p -- "$target" "$backup_root/$relative_path"
    fi
}

backup_if_present "$pi_dir/settings.json" "settings.json"

node - "$pi_dir/settings.json" "$source_root/settings.overlay.json" <<'NODE'
const fs = require("node:fs");
const path = process.argv[2];
const overlayPath = process.argv[3];
let current = {};
if (fs.existsSync(path)) {
  current = JSON.parse(fs.readFileSync(path, "utf8"));
}
const overlay = JSON.parse(fs.readFileSync(overlayPath, "utf8"));
const temporary = `${path}.tmp-${process.pid}`;
fs.writeFileSync(temporary, `${JSON.stringify({ ...current, ...overlay }, null, 2)}\n`, { mode: 0o600 });
fs.renameSync(temporary, path);
NODE

for relative_path in "${managed_files[@]}"; do
    target="$pi_dir/$relative_path"
    backup_if_present "$target" "$relative_path"
    mkdir -p "$(dirname "$target")"
    install -m 0644 "$source_root/$relative_path" "$target"
done

printf 'Applied Pi model routing to %s\n' "$pi_dir"
printf 'Backup: %s\n' "$backup_root"
