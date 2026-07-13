#!/usr/bin/env bash
set -euo pipefail

skill_path=""
target_path=""
format="checklist"
verbose=false
provided=()

usage() {
  printf '%s\n' 'Usage: inspect-runtime.sh --skill DIR [--target DIR] [--provide harness:NAME|mcp:NAME|verified:COMMAND] [--format checklist|tsv] [--verbose]'
  printf '%s\n' 'Audit runtime/requirements.tsv without installing or configuring providers.'
  printf '%s\n' 'Use --provide only for an agent-verified harness or MCP capability with target access.'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skill) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; skill_path="$2"; shift 2;;
    --target) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; target_path="$2"; shift 2;;
    --provide) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; provided+=("$2"); shift 2;;
    --format) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; format="$2"; shift 2;;
    --verbose) verbose=true; shift;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done

[ -n "$skill_path" ] || { printf '%s\n' '--skill is required.' >&2; exit 2; }
[ -d "$skill_path" ] || { printf 'Skill directory does not exist: %s\n' "$skill_path" >&2; exit 2; }
skill_path="$(cd "$skill_path" && pwd -P)"
[ -f "$skill_path/SKILL.md" ] || { printf 'SKILL.md does not exist: %s\n' "$skill_path" >&2; exit 2; }

case "$format" in checklist|tsv) ;; *) printf 'Unsupported format: %s\n' "$format" >&2; exit 2;; esac

if [ -n "$target_path" ]; then
  [ -d "$target_path" ] || { printf 'Target directory does not exist: %s\n' "$target_path" >&2; exit 2; }
  target_path="$(cd "$target_path" && pwd -P)"
fi

for provider in "${provided[@]}"; do
  [[ "$provider" =~ ^(harness|mcp):[a-z0-9]+([._-][a-z0-9]+)*$ || "$provider" =~ ^verified:[A-Za-z0-9][A-Za-z0-9._+-]*$ ]] || {
    printf 'Invalid caller-provided capability: %s\n' "$provider" >&2
    exit 2
  }
done

provider_declared() {
  local wanted="$1"
  local item
  for item in "${provided[@]}"; do
    [ "$item" != "$wanted" ] || return 0
  done
  return 1
}

command_origin() {
  local path="$1"
  case "$path" in
    *'/@openai/codex/'*|*'/codex-path/'*) printf '%s' 'harness-bundled' ;;
    "${HOME:-/__numados_no_home__}"/*) printf '%s' 'user' ;;
    /bin/*|/usr/*|/opt/homebrew/*) printf '%s' 'system' ;;
    *) printf '%s' 'custom' ;;
  esac
}

skill_name=""
while IFS= read -r metadata_line; do
  case "$metadata_line" in
    name:*) skill_name="${metadata_line#name:}"; skill_name="${skill_name# }"; break;;
  esac
done < "$skill_path/SKILL.md"
skill_name="${skill_name:-${skill_path##*/}}"
manifest="$skill_path/runtime/requirements.tsv"
if command -v uname >/dev/null 2>&1; then
  platform="$(uname -s 2>/dev/null || printf '%s' unknown)/$(uname -m 2>/dev/null || printf '%s' unknown)"
else
  platform="unknown"
fi

if [ ! -f "$manifest" ]; then
  printf 'skill: %s\n' "$skill_name"
  printf 'platform: %s\n' "$platform"
  printf '%s\n' 'status: undeclared'
  printf 'manifest: missing (%s)\n' "$manifest"
  printf '%s\n' 'recommendation: inspect SKILL.md and scripts, then add runtime/requirements.tsv'
  exit 0
fi

expected_header=$'# capability\tneed\twhen\tproviders\tpurpose'
actual_header=""
IFS= read -r actual_header < "$manifest" || true
[ "$actual_header" = "$expected_header" ] || {
  printf 'Invalid manifest header: %s\n' "$manifest" >&2
  exit 3
}

results=()
recommendations=()
field_separator=$'\x1f'
required_missing=0
optional_missing=0
entry_count=0
line_number=0

while IFS=$'\t' read -r capability need when providers purpose extra || [ -n "${capability:-}" ]; do
  line_number=$((line_number + 1))
  case "${capability:-}" in ''|\#*) continue;; esac

  [ -z "${extra:-}" ] && [ -n "${purpose:-}" ] || { printf 'Invalid manifest row %s: expected five tab-separated fields.\n' "$line_number" >&2; exit 3; }
  [[ "$capability" =~ ^[a-z0-9]+([._-][a-z0-9]+)*$ ]] || { printf 'Invalid capability at row %s: %s\n' "$line_number" "$capability" >&2; exit 3; }
  case "$need" in required|optional) ;; *) printf 'Invalid need at row %s: %s\n' "$line_number" "$need" >&2; exit 3;; esac
  [ -n "$when" ] && [ -n "$providers" ] || { printf 'Incomplete manifest row: %s\n' "$line_number" >&2; exit 3; }

  entry_count=$((entry_count + 1))
  available=""
  discovered_unready=""
  IFS='|' read -r -a alternatives <<< "$providers"
  for candidate in "${alternatives[@]}"; do
    case "$candidate" in
      cmd:*)
        command_name="${candidate#cmd:}"
        [[ "$command_name" =~ ^[A-Za-z0-9][A-Za-z0-9._+-]*$ ]] || { printf 'Invalid command provider at row %s: %s\n' "$line_number" "$candidate" >&2; exit 3; }
        if command_path="$(command -v "$command_name" 2>/dev/null)"; then
          origin="$(command_origin "$command_path")"
          if [ "$verbose" = true ]; then detail="$candidate=$command_path ($origin)"; else detail="$candidate ($origin)"; fi
          available="$detail"
        fi
        ;;
      verified:*)
        command_name="${candidate#verified:}"
        [[ "$command_name" =~ ^[A-Za-z0-9][A-Za-z0-9._+-]*$ ]] || { printf 'Invalid verified command at row %s: %s\n' "$line_number" "$candidate" >&2; exit 3; }
        if command_path="$(command -v "$command_name" 2>/dev/null)"; then
          origin="$(command_origin "$command_path")"
          if provider_declared "$candidate"; then
            if [ "$verbose" = true ]; then detail="$candidate=$command_path ($origin; caller-verified)"; else detail="$candidate ($origin; caller-verified)"; fi
            available="$detail"
          else
            detail="$candidate installed ($origin) but readiness is unverified"
            if [ -n "$discovered_unready" ]; then discovered_unready="$discovered_unready; $detail"; else discovered_unready="$detail"; fi
          fi
        fi
        ;;
      harness:*|mcp:*)
        [[ "$candidate" =~ ^(harness|mcp):[a-z0-9]+([._-][a-z0-9]+)*$ ]] || { printf 'Invalid external provider at row %s: %s\n' "$line_number" "$candidate" >&2; exit 3; }
        if provider_declared "$candidate"; then
          detail="$candidate (caller-verified)"
          available="$detail"
        fi
        ;;
      *) printf 'Unsupported provider at row %s: %s\n' "$line_number" "$candidate" >&2; exit 3;;
    esac
    [ -z "$available" ] || break
  done

  if [ -n "$available" ]; then
    results+=("PASS${field_separator}${need}${field_separator}${capability}${field_separator}${available}${field_separator}${when}${field_separator}${purpose}")
  else
    provider_evidence="$providers"
    [ -z "$discovered_unready" ] || provider_evidence="$provider_evidence; $discovered_unready"
    results+=("MISS${field_separator}${need}${field_separator}${capability}${field_separator}${provider_evidence}${field_separator}${when}${field_separator}${purpose}")
    recommendations+=("${need}${field_separator}${capability}${field_separator}${providers}${field_separator}${purpose}")
    if [ "$need" = required ]; then required_missing=$((required_missing + 1)); else optional_missing=$((optional_missing + 1)); fi
  fi
done < "$manifest"

[ "$entry_count" -gt 0 ] || { printf 'Runtime manifest has no capability rows: %s\n' "$manifest" >&2; exit 3; }

if [ "$required_missing" -gt 0 ]; then status="blocked"; elif [ "$optional_missing" -gt 0 ]; then status="ready-with-optional-gaps"; else status="ready"; fi

if [ "$format" = tsv ]; then
  printf 'meta\tskill\t%s\n' "$skill_name"
  printf 'meta\tplatform\t%s\n' "$platform"
  printf 'meta\ttarget\t%s\n' "${target_path:-(not supplied)}"
  printf 'meta\tstatus\t%s\n' "$status"
  for result in "${results[@]}"; do printf 'check\t%s\n' "${result//$field_separator/$'\t'}"; done
  for recommendation in "${recommendations[@]}"; do printf 'recommendation\t%s\n' "${recommendation//$field_separator/$'\t'}"; done
  exit 0
fi

printf 'skill: %s\n' "$skill_name"
printf 'platform: %s\n' "$platform"
printf 'target: %s\n' "${target_path:-(not supplied)}"
printf 'status: %s\n' "$status"
printf '%s\n' '[checks]'
for result in "${results[@]}"; do
  IFS="$field_separator" read -r result_status result_need result_capability result_provider result_when result_purpose <<< "$result"
  if [ "$result_status" = PASS ]; then
    printf '[x] %s %s — %s — %s\n' "$result_need" "$result_capability" "$result_provider" "$result_when"
  elif [ "$result_need" = required ]; then
    printf '[ ] required %s — unavailable; providers=%s — %s\n' "$result_capability" "$result_provider" "$result_when"
  else
    printf '[~] optional %s — unavailable; providers=%s — %s\n' "$result_capability" "$result_provider" "$result_when"
  fi
done

printf '%s\n' '[recommendations]'
if [ "${#recommendations[@]}" -eq 0 ]; then
  printf '%s\n' 'none'
else
  for recommendation in "${recommendations[@]}"; do
    IFS="$field_separator" read -r recommendation_need recommendation_capability recommendation_providers recommendation_purpose <<< "$recommendation"
    printf '%s %s — provide one of %s; %s\n' "$recommendation_need" "$recommendation_capability" "$recommendation_providers" "$recommendation_purpose"
  done
fi
