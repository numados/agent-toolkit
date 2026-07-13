#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -gt 0 ]; then
  case "$1" in
    --help|-h)
      printf '%s\n' 'Usage: probe-search-tools.sh'
      printf '%s\n' 'Report local search command identities and readiness gaps without installing or configuring tools.'
      exit 0
      ;;
    *) printf '%s\n' 'Usage: probe-search-tools.sh' >&2; exit 2;;
  esac
fi

origin() {
  local path="$1"
  case "$path" in
    *'/@openai/codex/'*|*'/codex-path/'*) printf '%s' 'harness-bundled';;
    "${HOME:-/__numados_no_home__}"/*) printf '%s' 'user';;
    /bin/*|/usr/*|/opt/homebrew/*) printf '%s' 'system';;
    *) printf '%s' 'custom';;
  esac
}

first_line() {
  local value="$1"
  printf '%s' "${value%%$'\n'*}"
}

print_check() {
  printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4"
}

if command_path="$(command -v rg 2>/dev/null)"; then
  version="$(rg --version 2>&1 || true)"
  print_check filesystem.lexical ready cmd:rg "$(first_line "$version"); $(origin "$command_path")"
  print_check filesystem.filename ready cmd:rg 'rg --files'
else
  print_check filesystem.lexical unavailable cmd:rg 'use a verified harness/MCP provider or ask doctor for setup options'
  if command_path="$(command -v fd 2>/dev/null)"; then
    print_check filesystem.filename ready cmd:fd "$(origin "$command_path")"
  elif command_path="$(command -v fdfind 2>/dev/null)"; then
    print_check filesystem.filename ready cmd:fdfind "$(origin "$command_path")"
  elif command_path="$(command -v find 2>/dev/null)"; then
    print_check filesystem.filename fallback cmd:find "$(origin "$command_path")"
  else
    print_check filesystem.filename unavailable none 'no filename provider detected'
  fi
fi

structural_state=unavailable
structural_provider=none
structural_evidence='ast-grep not detected'
for candidate in ast-grep sg; do
  if command_path="$(command -v "$candidate" 2>/dev/null)"; then
    version="$("$command_path" --version 2>&1 || true)"
    if [[ "${version,,}" == *ast-grep* ]]; then
      structural_state=detected
      structural_provider="cmd:$candidate"
      structural_evidence="$(first_line "$version"); verify language/query before use"
      break
    elif [ "$candidate" = sg ]; then
      structural_state=conflict
      structural_provider=cmd:sg
      structural_evidence="$(first_line "$version"); command is not ast-grep"
    fi
  fi
done
print_check code.structural "$structural_state" "$structural_provider" "$structural_evidence"

if command_path="$(command -v rga 2>/dev/null)"; then
  print_check document.extraction detected cmd:rga "$(origin "$command_path"); verify required format adapters"
else
  print_check document.extraction unavailable cmd:rga 'only relevant for PDF, Office, archives, media metadata, or SQLite'
fi

if command_path="$(command -v qmd 2>/dev/null)"; then
  print_check filesystem.semantic detected cmd:qmd "$(origin "$command_path"); collection, index, and model readiness unverified"
else
  print_check filesystem.semantic external-check none 'inspect harness/MCP semantic providers before recommending an index'
fi

if command_path="$(command -v plocate 2>/dev/null)"; then
  print_check filesystem.filename-index detected cmd:plocate "$(origin "$command_path"); index scope and freshness unverified"
elif command_path="$(command -v locate 2>/dev/null)"; then
  print_check filesystem.filename-index detected cmd:locate "$(origin "$command_path"); implementation, index scope, and freshness unverified"
else
  print_check filesystem.filename-index unavailable cmd:plocate/locate 'only relevant for repeated machine-wide filename lookup'
fi

if command_path="$(command -v git 2>/dev/null)"; then
  print_check history.git detected cmd:git "$(origin "$command_path"); target worktree unverified"
else
  print_check history.git unavailable cmd:git 'history search unavailable'
fi

print_check external.providers agent-check harness/mcp 'verify tool operation, root scope, bounds, side effects, and privacy in the active harness'
