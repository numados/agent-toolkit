#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd -P)"
doctor="$repo_root/skills/numados-skill-doctor/scripts/inspect-runtime.sh"
workflow_doctor="$repo_root/skills/numados-skill-doctor/scripts/inspect-development-workflow.sh"
curator_doctor="$repo_root/skills/numados-skill-doctor/scripts/inspect-knowledge-curator.sh"
safety_doctor="$repo_root/skills/numados-skill-doctor/scripts/inspect-safety.sh"
obsidian_skill="$repo_root/skills/numados-obsidian-knowledge"
local_search_skill="$repo_root/skills/numados-local-search"
temporary_root="$(mktemp -d)"
trap 'rm -rf "$temporary_root"' EXIT

checks=0

assert_contains() {
  local output="$1"
  local expected="$2"
  local label="$3"
  case "$output" in
    *"$expected"*) ;;
    *) printf 'FAIL %s: expected %s\n%s\n' "$label" "$expected" "$output" >&2; exit 1;;
  esac
  checks=$((checks + 1))
}

assert_not_contains() {
  local output="$1"
  local unexpected="$2"
  local label="$3"
  case "$output" in
    *"$unexpected"*) printf 'FAIL %s: unexpected %s\n%s\n' "$label" "$unexpected" "$output" >&2; exit 1;;
    *) ;;
  esac
  checks=$((checks + 1))
}

link_command() {
  local name="$1"
  local destination="$2"
  ln -s "$(command -v "$name")" "$destination/$name"
}

mkdir -p "$temporary_root/vault/tasks" "$temporary_root/vault/knowledge" "$temporary_root/project" "$temporary_root/bin-ready" "$temporary_root/bin-no-rg"
for command_name in bash dirname uname node; do
  link_command "$command_name" "$temporary_root/bin-ready"
  link_command "$command_name" "$temporary_root/bin-no-rg"
done
true_path="$(type -P true)"
ln -s "$true_path" "$temporary_root/bin-ready/rg"
ln -s "$true_path" "$temporary_root/bin-ready/qmd"

output="$(PATH="$temporary_root/bin-ready" "$doctor" \
  --skill "$obsidian_skill" \
  --target "$temporary_root/vault" \
  --provide harness:filesystem-search)"
assert_contains "$output" '[x] required filesystem.lexical — cmd:rg (custom)' 'provider priority'
assert_not_contains "$output" '[x] required filesystem.lexical — harness:filesystem-search' 'single selected provider'
assert_contains "$output" 'verified:qmd installed (custom) but readiness is unverified' 'stateful provider gate'

output="$(PATH="$temporary_root/bin-ready" "$doctor" \
  --skill "$obsidian_skill" \
  --target "$temporary_root/vault" \
  --provide verified:qmd)"
assert_contains "$output" '[x] optional filesystem.semantic — verified:qmd (custom; caller-verified)' 'verified stateful provider'

output="$(PATH="$temporary_root/bin-no-rg" "$doctor" \
  --skill "$obsidian_skill" \
  --target "$temporary_root/vault" \
  --provide harness:filesystem-search)"
assert_contains "$output" '[x] required filesystem.lexical — harness:filesystem-search (caller-verified)' 'harness fallback'

output="$(PATH="$temporary_root/bin-no-rg" "$doctor" \
  --skill "$obsidian_skill" \
  --target "$temporary_root/vault")"
assert_contains "$output" 'status: blocked' 'missing required provider'

mkdir -p "$temporary_root/safety-home/.codex/execpolicy"
printf '%s\n' \
  'prefix_rule(' \
  '  pattern = ["git", "push"],' \
  '  decision = "forbidden",' \
  '  justification = "test",' \
  ')' > "$temporary_root/safety-home/.codex/execpolicy/numados-safety.rules"
printf '%s\n' \
  '[execpolicy]' \
  'user_rules = ["~/.codex/execpolicy/numados-safety.rules"]' > "$temporary_root/safety-home/.codex/config.toml"
output="$(HOME="$temporary_root/safety-home" CODEX_HOME="$temporary_root/safety-home/.codex" PATH="$temporary_root/bin-no-rg" "$safety_doctor" --harness codex)"
assert_contains "$output" 'Codex config references the Numados execpolicy rule' 'active harness safety scope'
assert_contains "$output" 'Safety status: READY WITH GAPS' 'native safety availability gap'
assert_not_contains "$output" 'Claude' 'single harness safety audit'
assert_not_contains "$output" 'Pi' 'single harness safety audit'
if "$safety_doctor" >/dev/null 2>&1; then
  printf '%s\n' 'FAIL safety doctor accepted an unspecified harness' >&2
  exit 1
fi
if "$safety_doctor" --harness all >/dev/null 2>&1; then
  printf '%s\n' 'FAIL safety doctor accepted an all-harness audit' >&2
  exit 1
fi
checks=$((checks + 1))

XDG_CONFIG_HOME="$temporary_root/config" \
  "$obsidian_skill/scripts/configure-vault.sh" \
  --profile workflow \
  --vault "$temporary_root/vault" \
  --project "$temporary_root/project" \
  --write-root tasks \
  --knowledge-root knowledge >/dev/null
output="$(XDG_CONFIG_HOME="$temporary_root/config" \
  "$obsidian_skill/scripts/validate-vault-context.sh" \
  --start-dir "$temporary_root/project")"
assert_contains "$output" 'knowledge_root: knowledge' 'dedicated knowledge root'
output="$(XDG_CONFIG_HOME="$temporary_root/config" "$workflow_doctor" \
  --root "$repo_root" \
  --target "$temporary_root/project" \
  --provide harness:skill-invocation \
  --provide harness:filesystem-write \
  --provide verified:git \
  --provide harness:test-runner)"
assert_contains "$output" 'Workflow: numados-development' 'workflow bundle audit'
assert_contains "$output" 'Status: ready' 'workflow bundle readiness'
assert_contains "$output" '[x] required storage.obsidian' 'workflow storage readiness'
assert_contains "$output" '[x] required protocol.plan-extension' 'workflow plan extension'
assert_not_contains "$output" 'Status: blocked' 'optional semantic gap does not block workflow'

output="$(XDG_CONFIG_HOME="$temporary_root/config" "$curator_doctor" \
  --root "$repo_root" \
  --target "$temporary_root/project" \
  --provide harness:skill-invocation \
  --provide harness:filesystem-write)"
assert_contains "$output" 'Status: READY' 'knowledge curator readiness'
assert_contains "$output" 'knowledge root resolves inside the vault: knowledge' 'knowledge curator root'

mkdir -p "$temporary_root/malformed/runtime"
printf '%s\n' '---' 'name: malformed' 'description: test' '---' > "$temporary_root/malformed/SKILL.md"
printf '%s\n' 'wrong header' > "$temporary_root/malformed/runtime/requirements.tsv"
if PATH="$temporary_root/bin-no-rg" "$doctor" --skill "$temporary_root/malformed" >/dev/null 2>&1; then
  printf '%s\n' 'FAIL malformed header: doctor accepted it' >&2
  exit 1
fi
checks=$((checks + 1))

mkdir -p "$temporary_root/project/.numados" "$temporary_root/project/nested"
printf '%s\n' 'missing-profile' > "$temporary_root/project/.numados/obsidian-profile"
output="$(env -u NUMADOS_OBSIDIAN_VAULT -u NUMADOS_OBSIDIAN_PROFILE \
  "$obsidian_skill/scripts/resolve-vault.sh" \
  --vault "$temporary_root/vault" \
  --start-dir "$temporary_root/project/nested" \
  --show-context)"
assert_contains "$output" 'source: explicit-vault' 'explicit vault precedence'

mkdir -p "$temporary_root/outside"
ln -s "$temporary_root/outside" "$temporary_root/vault/escape"
if XDG_CONFIG_HOME="$temporary_root/config" \
  "$obsidian_skill/scripts/configure-vault.sh" \
  --profile test \
  --vault "$temporary_root/vault" \
  --write-root escape >/dev/null 2>&1; then
  printf '%s\n' 'FAIL symlink containment: outside directory accepted' >&2
  exit 1
fi
checks=$((checks + 1))

if PATH="$temporary_root/bin-no-rg" \
  "$obsidian_skill/scripts/vault-search.sh" \
  --vault "$temporary_root/vault" \
  --query test >/dev/null 2>&1; then
  printf '%s\n' 'FAIL missing rg: search returned success' >&2
  exit 1
fi
checks=$((checks + 1))

if command -v rg >/dev/null 2>&1; then
  printf '%s\n' 'bounded needle one' > "$temporary_root/vault/one.md"
  printf '%s\n' 'bounded needle two' > "$temporary_root/vault/two.md"
  output="$("$obsidian_skill/scripts/vault-search.sh" \
    --vault "$temporary_root/vault" \
    --query 'bounded needle' \
    --mode text \
    --limit 1 \
    --context 0)"
  match_count="$(printf '%s\n' "$output" | grep -c 'bounded needle')"
  [ "$match_count" -eq 1 ] || { printf 'FAIL bounded search: expected 1 snippet, got %s\n%s\n' "$match_count" "$output" >&2; exit 1; }
  checks=$((checks + 1))

  mkdir -p "$temporary_root/search"
  printf '%s\n' 'semantic needle one' > "$temporary_root/search/one.md"
  printf '%s\n' 'semantic needle two' > "$temporary_root/search/two.md"
  output="$("$local_search_skill/scripts/bounded-search.sh" \
    --root "$temporary_root/search" \
    --query 'semantic needle' \
    --mode text \
    --limit 1 \
    --context 0)"
  match_count="$(printf '%s\n' "$output" | grep -c 'semantic needle')"
  [ "$match_count" -eq 1 ] || { printf 'FAIL local bounded search: expected 1 snippet, got %s\n%s\n' "$match_count" "$output" >&2; exit 1; }
  checks=$((checks + 1))

  mkdir -p "$temporary_root/search/.git"
  printf '%s\n' 'semantic needle vcs metadata' > "$temporary_root/search/.git/hidden.md"
  output="$("$local_search_skill/scripts/bounded-search.sh" \
    --root "$temporary_root/search" \
    --query 'semantic needle' \
    --mode text \
    --hidden \
    --limit 10 \
    --context 0)"
  assert_not_contains "$output" '.git/hidden.md' 'vcs metadata exclusion'
fi

if "$local_search_skill/scripts/bounded-search.sh" \
  --root / \
  --query test \
  --mode path >/dev/null 2>&1; then
  printf '%s\n' 'FAIL filesystem root guard: / search returned success' >&2
  exit 1
fi
checks=$((checks + 1))

if "$local_search_skill/scripts/bounded-search.sh" \
  --root "$temporary_root" \
  --query '[' \
  --mode regex >/dev/null 2>&1; then
  printf '%s\n' 'FAIL invalid regex: search returned success' >&2
  exit 1
fi
checks=$((checks + 1))

mkdir -p "$temporary_root/bin-sg-conflict"
link_command bash "$temporary_root/bin-sg-conflict"
printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\n" "ripgrep test"' > "$temporary_root/bin-sg-conflict/rg"
printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\n" "Usage: sg group [[-c] command]"' > "$temporary_root/bin-sg-conflict/sg"
chmod +x "$temporary_root/bin-sg-conflict/rg" "$temporary_root/bin-sg-conflict/sg"
output="$(PATH="$temporary_root/bin-sg-conflict" "$local_search_skill/scripts/probe-search-tools.sh")"
assert_contains "$output" $'code.structural\tconflict\tcmd:sg' 'ast-grep command collision'

printf 'PASS runtime checks: %s\n' "$checks"
