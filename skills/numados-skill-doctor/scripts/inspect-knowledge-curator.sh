#!/usr/bin/env bash
set -euo pipefail

root=""
target=""
vault=""
mode="curate"
provided=()

usage() {
  printf '%s\n' 'Usage: inspect-knowledge-curator.sh --root DIR (--target DIR|--vault DIR) [--mode query|curate] [--provide PROVIDER]'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --root) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; root="$2"; shift 2;;
    --target) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; target="$2"; shift 2;;
    --vault) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; vault="$2"; shift 2;;
    --mode) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; mode="$2"; shift 2;;
    --provide) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; provided+=(--provide "$2"); shift 2;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done

[ -n "$root" ] || { printf '%s\n' '--root is required.' >&2; exit 2; }
[ "$mode" = query ] || [ "$mode" = curate ] || { printf 'Unsupported mode: %s\n' "$mode" >&2; exit 2; }
[ -d "$root" ] || { printf 'Toolkit root does not exist: %s\n' "$root" >&2; exit 2; }
[ -z "$target" ] || [ -z "$vault" ] || { printf '%s\n' '--target and --vault are mutually exclusive.' >&2; exit 2; }
[ -n "$target" ] || [ -n "$vault" ] || { printf '%s\n' '--target or --vault is required.' >&2; exit 2; }

root="$(cd "$root" && pwd -P)"
scope="$target"
[ -n "$scope" ] || scope="$vault"
[ -d "$scope" ] || { printf 'Scope does not exist: %s\n' "$scope" >&2; exit 2; }
scope="$(cd "$scope" && pwd -P)"

curator="$root/skills/numados-knowledge-curator"
obsidian="$root/skills/numados-obsidian-knowledge"
runtime="$root/skills/numados-skill-doctor/scripts/inspect-runtime.sh"
validator="$obsidian/scripts/validate-vault-context.sh"
blocked=0

check() {
  if [ "$1" = pass ]; then printf '[x] %s\n' "$2"; else printf '[ ] %s\n' "$2"; blocked=$((blocked + 1)); fi
}

printf '%s\n' 'Skill: numados-knowledge-curator'
printf 'Mode: %s\n' "$mode"
if [ -f "$curator/SKILL.md" ] && [ -f "$curator/runtime/requirements.tsv" ] && [ -f "$obsidian/SKILL.md" ]; then
  check pass 'composition — curator and Obsidian skill are installed'
else
  check fail 'composition — curator or Obsidian skill is missing'
fi

runtime_output=""
if [ -x "$runtime" ] && [ -d "$curator" ]; then
  runtime_output="$($runtime --skill "$curator" --target "$scope" "${provided[@]}" 2>&1 || true)"
fi
if printf '%s\n' "$runtime_output" | grep -Eq '^status: ready(-with-optional-gaps)?$'; then
  check pass 'runtime — required providers are ready for the target'
else
  check fail 'runtime — required provider is missing or not target-applicable'
fi
if [ "$mode" = curate ]; then
  if printf '%s\n' "$runtime_output" | grep -Fq '[x] optional storage.knowledge-write'; then
    check pass 'mutation — knowledge-root write provider is ready'
  else
    check fail 'mutation — curate mode requires a target-applicable knowledge-root write provider'
  fi
else
  check pass 'mutation — query mode is read-only'
fi

context_output=""
if [ -n "$target" ]; then
  context_output="$($validator --start-dir "$scope" 2>&1 || true)"
else
  context_output="$($validator --vault "$scope" --start-dir "$scope" 2>&1 || true)"
fi
if printf '%s\n' "$context_output" | grep -Eq '^knowledge_root: .+' &&
  ! printf '%s\n' "$context_output" | grep -Fq 'knowledge_root: (not configured'; then
  knowledge_root="$(printf '%s\n' "$context_output" | sed -n 's/^knowledge_root: //p' | tail -n 1)"
  check pass "storage — knowledge root resolves inside the vault: $knowledge_root"
else
  check fail 'storage — NUMADOS_OBSIDIAN_KNOWLEDGE_ROOT is not configured or invalid'
fi

if [ "$blocked" -eq 0 ]; then status=READY; else status=BLOCKED; fi
printf 'Status: %s\n' "$status"
if [ "$blocked" -eq 0 ]; then
  printf '%s\n' 'Action: none'
else
  printf '%s\n' 'Action: configure the missing profile/root or provider, then rerun this audit'
fi
[ "$blocked" -eq 0 ]
