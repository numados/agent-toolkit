#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: setup-harness-instructions.sh [--check|--apply] [--harness NAME]

Install or verify the shared instructions for supported user-level harnesses.

Options:
  --check             Verify the installation without changing files (default).
  --apply             Create missing directories and symlinks; never overwrite.
  --harness NAME      Check one harness: codex, claude, pi, or all (default).
EOF
}

mode="check"
harness="all"

while [ "$#" -gt 0 ]; do
    case "$1" in
        --check)
            mode="check"
            ;;
        --apply)
            mode="apply"
            ;;
        --harness)
            shift
            [ "$#" -gt 0 ] || { usage >&2; exit 2; }
            harness="$1"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            exit 2
            ;;
    esac
    shift
done

case "$harness" in
    all|codex|claude|pi) ;;
    *)
        printf 'ERROR: unsupported harness "%s"\n' "$harness" >&2
        exit 2
        ;;
esac

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
instruction_source="$repo_root/instructions/global-instructions.md"

if [ ! -f "$instruction_source" ]; then
    printf 'ERROR: instruction source is missing: %s\n' "$instruction_source" >&2
    exit 1
fi

expected_toolkit="$HOME/numados/agent-toolkit"
status=0

check_toolkit_path() {
    if [ ! -e "$expected_toolkit" ]; then
        printf 'ERROR: expected toolkit path is missing: %s\n' "$expected_toolkit" >&2
        printf '       Clone this repository there or create that path as a symlink.\n' >&2
        status=1
        return
    fi

    toolkit_physical="$(cd -- "$expected_toolkit" && pwd -P)"
    if [ "$toolkit_physical" != "$repo_root" ]; then
        printf 'ERROR: %s resolves to %s, not %s\n' "$expected_toolkit" "$toolkit_physical" "$repo_root" >&2
        status=1
    else
        printf 'OK: toolkit path %s\n' "$expected_toolkit"
    fi
}

check_adapter_files() {
    for adapter in codex-instructions.md claude-code-instructions.md; do
        adapter_path="$expected_toolkit/adapters/$adapter"
        if [ -f "$adapter_path" ]; then
            printf 'OK: adapter %s\n' "$adapter_path"
        else
            printf 'ERROR: adapter is missing: %s\n' "$adapter_path" >&2
            status=1
        fi
    done
}

check_link() {
    target="$1"

    if [ -L "$target" ]; then
        actual="$(readlink "$target")"
        if [ "$actual" = "$instruction_source" ]; then
            printf 'OK: %s -> %s\n' "$target" "$instruction_source"
        else
            printf 'ERROR: %s points to %s; expected %s\n' "$target" "$actual" "$instruction_source" >&2
            status=1
        fi
    elif [ -e "$target" ]; then
        printf 'ERROR: %s exists and is not the managed symlink; refusing to overwrite it\n' "$target" >&2
        status=1
    else
        printf 'MISSING: %s\n' "$target"
        if [ "$mode" = "apply" ]; then
            mkdir -p "$(dirname -- "$target")"
            ln -s "$instruction_source" "$target"
            printf 'ADDED: %s -> %s\n' "$target" "$instruction_source"
        else
            status=1
        fi
    fi
}

check_toolkit_path
check_adapter_files

if [ "$mode" = "apply" ] && [ "$status" -ne 0 ]; then
    printf 'BLOCKED: prerequisites are not valid; no files were changed\n' >&2
    exit "$status"
fi

case "$harness" in
    all|codex)
        check_link "$HOME/.codex/AGENTS.md"
        ;;
esac
case "$harness" in
    all|claude)
        check_link "$HOME/.claude/CLAUDE.md"
        ;;
esac
case "$harness" in
    all|pi)
        check_link "$HOME/.pi/agent/AGENTS.md"
        ;;
esac

if [ "$mode" = "apply" ] && [ "$status" -eq 0 ]; then
    printf 'APPLIED: harness instruction links are ready\n'
elif [ "$status" -eq 0 ]; then
    printf 'VERIFIED: harness instruction links are ready\n'
else
    printf 'BLOCKED: resolve the errors above; no existing user file was overwritten\n' >&2
fi

exit "$status"
