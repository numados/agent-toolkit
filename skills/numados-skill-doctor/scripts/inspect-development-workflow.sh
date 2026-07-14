#!/usr/bin/env bash
set -euo pipefail

root=""
target=""
vault=""
provided=()

usage() {
  printf '%s\n' 'Usage: inspect-development-workflow.sh --root DIR [--target DIR|--vault DIR] [--provide harness:NAME|mcp:NAME|verified:COMMAND]'
  printf '%s\n' 'Audit the Numados development workflow bundle without installing or mutating providers.'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --root) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; root="$2"; shift 2;;
    --target) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; target="$2"; shift 2;;
    --vault) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; vault="$2"; shift 2;;
    --provide) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; provided+=("$2"); shift 2;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done

[ -n "$root" ] || { printf '%s\n' '--root is required.' >&2; exit 2; }
[ -d "$root" ] || { printf 'Toolkit root does not exist: %s\n' "$root" >&2; exit 2; }
root="$(cd "$root" && pwd -P)"

if [ -n "$target" ] && [ -n "$vault" ]; then
  printf '%s\n' '--target and --vault are mutually exclusive.' >&2
  exit 2
fi
if [ -n "$target" ]; then
  [ -d "$target" ] || { printf 'Target directory does not exist: %s\n' "$target" >&2; exit 2; }
  target="$(cd "$target" && pwd -P)"
fi
if [ -n "$vault" ]; then
  [ -d "$vault" ] || { printf 'Vault directory does not exist: %s\n' "$vault" >&2; exit 2; }
  vault="$(cd "$vault" && pwd -P)"
fi

for provider in "${provided[@]}"; do
  [[ "$provider" =~ ^(harness|mcp):[a-z0-9]+([._-][a-z0-9]+)*$ || "$provider" =~ ^verified:[A-Za-z0-9][A-Za-z0-9._+-]*$ ]] || {
    printf 'Invalid caller-provided capability: %s\n' "$provider" >&2
    exit 2
  }
done

has_provider() {
  local wanted="$1"
  local item
  for item in "${provided[@]}"; do
    [ "$item" != "$wanted" ] || return 0
  done
  return 1
}

has_any_provider() {
  local item
  for item in "$@"; do
    if has_provider "$item"; then return 0; fi
  done
  return 1
}

contains() {
  local needle="$1"
  local file="$2"
  grep -Fq -- "$needle" "$file"
}

checks=()
blocked=0
optional_gaps=0

check_required() {
  local label="$1"
  local detail="$2"
  if [ "$3" = pass ]; then
    checks+=("[x] required ${label} — ${detail}")
  else
    checks+=("[ ] required ${label} — ${detail}")
    blocked=$((blocked + 1))
  fi
}

check_optional() {
  local label="$1"
  local detail="$2"
  if [ "$3" = pass ]; then
    checks+=("[x] optional ${label} — ${detail}")
  else
    checks+=("[~] optional ${label} — ${detail}")
    optional_gaps=$((optional_gaps + 1))
  fi
}

required_skills=(
  numados-brainstorm
  numados-gap-drill
  numados-planning
  numados-implementation
  numados-task-navigator
  numados-obsidian-knowledge
  numados-code-review
  numados-verify-finding
  numados-commit-message
)

for skill in "${required_skills[@]}"; do
  skill_dir="$root/skills/$skill"
  if [ -f "$skill_dir/SKILL.md" ] && [ -f "$skill_dir/agents/openai.yaml" ] && [ -f "$skill_dir/runtime/requirements.tsv" ]; then
    check_required "skill.$skill" 'SKILL.md, UI metadata, and runtime manifest present' pass
  else
    check_required "skill.$skill" 'missing SKILL.md, agents/openai.yaml, or runtime/requirements.tsv' fail
  fi
done

contract="$root/contracts/development-workflow-artifacts.md"
if [ -f "$contract" ] && contains 'numados-task-iteration-v1' "$contract" && contains 'iterations/' "$contract" && contains 'remarks.md' "$contract"; then
  check_required 'protocol.contract' 'event format, iterations, and separate remarks are defined' pass
else
  check_required 'protocol.contract' 'contract is missing or does not define the event/remarks protocol' fail
fi

for skill in numados-brainstorm numados-gap-drill numados-planning numados-implementation numados-task-navigator; do
  skill_file="$root/skills/$skill/SKILL.md"
  if [ -f "$skill_file" ] && contains 'numados-obsidian-knowledge' "$skill_file" && contains 'latest_iteration' "$skill_file"; then
    check_required "protocol.$skill" 'starts from Obsidian task state and latest iteration' pass
  else
    check_required "protocol.$skill" 'skill does not declare bounded Obsidian recovery' fail
  fi
done

for skill in numados-brainstorm numados-gap-drill numados-planning numados-implementation; do
  manifest="$root/skills/$skill/runtime/requirements.tsv"
  if [ -f "$manifest" ] && contains $'skill.obsidian-knowledge\trequired' "$manifest" && contains $'storage.task-write\trequired' "$manifest"; then
    check_required "manifest.$skill" 'requires Obsidian composition and task writes' pass
  else
    check_required "manifest.$skill" 'missing required Obsidian/task-write capability declarations' fail
  fi
done

task_manifest="$root/skills/numados-task-navigator/runtime/requirements.tsv"
if [ -f "$task_manifest" ] && contains $'skill.obsidian-knowledge\trequired' "$task_manifest"; then
  check_required 'manifest.numados-task-navigator' 'requires Obsidian task-state retrieval' pass
else
  check_required 'manifest.numados-task-navigator' 'missing Obsidian retrieval declaration' fail
fi

obsidian_reference="$root/skills/numados-obsidian-knowledge/references/task-iterations.md"
if [ -f "$obsidian_reference" ] && contains 'numados-task-iteration-v1' "$obsidian_reference" && contains 'latest_iteration' "$obsidian_reference"; then
  check_required 'protocol.obsidian-task-iterations' 'read/write/verify protocol is bundled' pass
else
  check_required 'protocol.obsidian-task-iterations' 'task-iterations reference is missing or incomplete' fail
fi

implementation_file="$root/skills/numados-implementation/SKILL.md"
if [ -f "$implementation_file" ] && contains 'numados-code-review' "$implementation_file" && contains 'numados-verify-finding' "$implementation_file"; then
  check_required 'protocol.review-loop' 'implementation delegates review and finding validation' pass
else
  check_required 'protocol.review-loop' 'review/verify composition is missing' fail
fi

planning_file="$root/skills/numados-planning/SKILL.md"
if [ -f "$planning_file" ] && contains 'stable phase IDs' "$planning_file" && contains 'append new stable phase IDs' "$planning_file"; then
  check_required 'protocol.plan-extension' 'planning can add phases without renumbering completed work' pass
else
  check_required 'protocol.plan-extension' 'plan-extension rule is missing' fail
fi

if command -v rg >/dev/null 2>&1; then
  rg_path="$(command -v rg)"
  check_required 'provider.filesystem.filename' "cmd:rg ($rg_path)" pass
  check_required 'provider.filesystem.lexical' "cmd:rg ($rg_path)" pass
elif command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1 || command -v find >/dev/null 2>&1; then
  search_command="$(command -v fd 2>/dev/null || command -v fdfind 2>/dev/null || command -v find)"
  check_required 'provider.filesystem.filename' "$search_command" pass
  if has_any_provider harness:filesystem-search mcp:filesystem-search; then
    check_required 'provider.filesystem.lexical' 'caller-verified filesystem search' pass
  else
    check_required 'provider.filesystem.lexical' 'install rg (recommended) or expose a caller-verified filesystem-search provider for bounded content retrieval' fail
  fi
elif has_any_provider harness:filesystem-search mcp:filesystem-search; then
  check_required 'provider.filesystem.filename' 'caller-verified filesystem search' pass
  check_required 'provider.filesystem.lexical' 'caller-verified filesystem search' pass
else
  check_required 'provider.filesystem.filename' 'install rg/fd or expose find or a target-applicable filesystem-search provider' fail
  check_required 'provider.filesystem.lexical' 'install rg or expose a target-applicable filesystem-search provider' fail
fi

if has_any_provider harness:skill-invocation mcp:skill-invocation; then
  check_required 'provider.skill-invocation' 'caller-verified skill composition' pass
else
  check_required 'provider.skill-invocation' 'configure/expose harness:skill-invocation after verifying the active harness can invoke the named skills' fail
fi

if has_any_provider harness:filesystem-write mcp:obsidian; then
  check_required 'provider.task-write' 'caller-verified Obsidian/filesystem write with target access' pass
else
  check_required 'provider.task-write' 'configure/expose harness:filesystem-write or mcp:obsidian with the resolved vault' fail
fi

if has_provider verified:git && command -v git >/dev/null 2>&1; then
  check_required 'provider.git' "verified:git ($(command -v git))" pass
elif has_provider harness:git || has_provider mcp:git; then
  check_required 'provider.git' 'caller-verified Git provider' pass
else
  check_required 'provider.git' 'install/verify git and provide verified:git (or a target-applicable Git provider)' fail
fi

test_runner=''
for candidate in dotnet cargo npm pnpm yarn make; do
  if command -v "$candidate" >/dev/null 2>&1 && has_provider "verified:$candidate"; then
    test_runner="verified:$candidate ($(command -v "$candidate"))"
    break
  fi
done
if [ -n "$test_runner" ]; then
  check_required 'provider.test-runner' "$test_runner" pass
elif has_any_provider harness:test-runner mcp:test-runner; then
  check_required 'provider.test-runner' 'caller-verified repository test runner' pass
else
  check_required 'provider.test-runner' 'configure/expose harness:test-runner or verify an available runner such as verified:dotnet/verified:cargo' fail
fi

if has_any_provider harness:semantic-search mcp:semantic-search verified:qmd mcp:qmd || command -v qmd >/dev/null 2>&1; then
  check_optional 'provider.semantic-search' 'available as an optional route; verify target/index applicability before use' pass
else
  check_optional 'provider.semantic-search' 'not available; lexical/structural retrieval remains the default and QMD is not required' fail
fi

context_validator="$root/skills/numados-obsidian-knowledge/scripts/validate-vault-context.sh"
storage_output=''
storage_ok=false
if [ -n "$vault" ]; then
  if storage_output="$($context_validator --vault "$vault" --start-dir "$vault" 2>&1)"; then storage_ok=true; fi
elif [ -n "$target" ]; then
  if storage_output="$($context_validator --start-dir "$target" 2>&1)"; then storage_ok=true; fi
fi

if [ "$storage_ok" = true ] && printf '%s\n' "$storage_output" | grep -Eq '^write_root: .+' && ! printf '%s\n' "$storage_output" | grep -Fq 'write_root: (not configured; explicit destination required)'; then
  check_required 'storage.obsidian' 'resolved vault/profile and deterministic write_root' pass
elif [ -z "$vault" ] && [ -z "$target" ]; then
  check_required 'storage.obsidian' 'target/vault scope is unknown; provide --target or --vault so profile and write_root can be checked' fail
else
  detail='cannot resolve a valid vault/profile or deterministic write_root'
  if [ -n "$storage_output" ]; then
    write_root_line="$(printf '%s\n' "$storage_output" | grep -F 'write_root:' | tail -n 1 || true)"
    if [ -n "$write_root_line" ]; then detail="$detail; $write_root_line"; else detail="$detail; $(printf '%s\n' "$storage_output" | tail -n 1)"; fi
  fi
  check_required 'storage.obsidian' "$detail" fail
fi

if [ "$blocked" -gt 0 ]; then status='blocked'; elif [ "$optional_gaps" -gt 0 ]; then status='ready-with-optional-gaps'; else status='ready'; fi

printf '%s\n' 'Workflow: numados-development'
printf 'Root: %s\n' "$root"
printf 'Target: %s\n' "${target:-${vault:-(not supplied)}}"
printf 'Status: %s\n' "$status"
printf '%s\n' '[checklist]'
for check in "${checks[@]}"; do printf '%s\n' "$check"; done

printf '%s\n' '[actions]'
if [ "$blocked" -eq 0 ]; then
  printf '%s\n' 'Required: none'
else
  printf '%s\n' 'Required: resolve each unchecked capability above; this doctor does not install or configure it.'
fi
if [ "$optional_gaps" -eq 0 ]; then
  printf '%s\n' 'Optional: none'
else
  printf '%s\n' 'Optional: semantic/indexed retrieval is not required for exact task recovery; add it only when conceptual search justifies index cost.'
fi
