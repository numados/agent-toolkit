#!/usr/bin/env bash
set -euo pipefail

skills_root="skills"
if [ "$#" -gt 0 ]; then
    skills_root="$1"
fi

status=0
found=0

for skill_file in "$skills_root"/*/SKILL.md; do
    [ -e "$skill_file" ] || continue
    found=1

    skill_dir="$(basename "$(dirname "$skill_file")")"
    first_line="$(sed -n '1p' "$skill_file")"
    if [ "$first_line" != "---" ]; then
        printf 'ERROR %s: missing YAML frontmatter\n' "$skill_file" >&2
        status=1
        continue
    fi

    frontmatter="$(awk 'NR > 1 && $0 == "---" { exit } NR > 1 { print }' "$skill_file")"
    name="$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)"
    description="$(printf '%s\n' "$frontmatter" | sed -n 's/^description:[[:space:]]*//p' | head -n 1)"

    if [ -z "$name" ]; then
        printf 'ERROR %s: missing name\n' "$skill_file" >&2
        status=1
    elif [ "$name" != "$skill_dir" ]; then
        printf 'ERROR %s: name "%s" must match directory "%s"\n' "$skill_file" "$name" "$skill_dir" >&2
        status=1
    fi

    if [ -z "$description" ]; then
        printf 'ERROR %s: missing description\n' "$skill_file" >&2
        status=1
    fi

    skill_root="$(dirname "$skill_file")"
    while IFS= read -r reference; do
        [ -n "$reference" ] || continue
        reference_path="${reference%%#*}"
        if [ ! -e "$skill_root/$reference_path" ]; then
            printf 'ERROR %s: missing bundled resource %s\n' "$skill_file" "$reference_path" >&2
            status=1
        fi
    done < <(grep -oE '\]\((\./)?(references|scripts|assets)/[^)#[:space:]]+(#[^)]*)?\)' "$skill_file" \
        | sed -e 's/^](//' -e 's/)$//' || true)

    agent_file="$skill_root/agents/openai.yaml"
    if [ -f "$agent_file" ]; then
        short_description="$(sed -n 's/^  short_description: "\(.*\)"$/\1/p' "$agent_file")"
        default_prompt="$(sed -n 's/^  default_prompt: "\(.*\)"$/\1/p' "$agent_file")"
        if [ "${#short_description}" -lt 25 ] || [ "${#short_description}" -gt 64 ]; then
            printf 'ERROR %s: short_description must be 25-64 characters\n' "$agent_file" >&2
            status=1
        fi
        case "$default_prompt" in
            *\$"$name"*) ;;
            *) printf 'ERROR %s: default_prompt must mention $%s\n' "$agent_file" "$name" >&2; status=1;;
        esac
    fi

    if [[ "$skill_dir" == numados-* ]]; then
        if [ ! -f "tests/skills/$skill_dir.md" ]; then
            printf 'ERROR %s: missing behavior evaluations\n' "$skill_dir" >&2
            status=1
        fi
        if [ ! -f "tests/skills/$skill_dir.triggers.json" ]; then
            printf 'ERROR %s: missing trigger evaluations\n' "$skill_dir" >&2
            status=1
        fi
    fi

    runtime_file="$skill_root/runtime/requirements.tsv"
    if [ -f "$runtime_file" ]; then
        expected_header=$'# capability\tneed\twhen\tproviders\tpurpose'
        actual_header="$(sed -n '1p' "$runtime_file")"
        if [ "$actual_header" != "$expected_header" ]; then
            printf 'ERROR %s: invalid header\n' "$runtime_file" >&2
            status=1
        fi

        runtime_entries=0
        runtime_line=0
        while IFS=$'\t' read -r capability need when providers purpose extra || [ -n "${capability:-}" ]; do
            runtime_line=$((runtime_line + 1))
            case "${capability:-}" in ''|\#*) continue;; esac
            runtime_entries=$((runtime_entries + 1))

            if [ -n "${extra:-}" ] || [ -z "${when:-}" ] || [ -z "${providers:-}" ] || [ -z "${purpose:-}" ]; then
                printf 'ERROR %s:%s: expected five non-empty tab-separated fields\n' "$runtime_file" "$runtime_line" >&2
                status=1
                continue
            fi
            if ! [[ "$capability" =~ ^[a-z0-9]+([._-][a-z0-9]+)*$ ]]; then
                printf 'ERROR %s:%s: invalid capability "%s"\n' "$runtime_file" "$runtime_line" "$capability" >&2
                status=1
            fi
            case "$need" in
                required|optional) ;;
                *) printf 'ERROR %s:%s: invalid need "%s"\n' "$runtime_file" "$runtime_line" "$need" >&2; status=1;;
            esac

            IFS='|' read -r -a provider_list <<< "$providers"
            for provider in "${provider_list[@]}"; do
                if ! [[ "$provider" =~ ^cmd:[A-Za-z0-9][A-Za-z0-9._+-]*$|^verified:[A-Za-z0-9][A-Za-z0-9._+-]*$|^(harness|mcp):[a-z0-9]+([._-][a-z0-9]+)*$ ]]; then
                    printf 'ERROR %s:%s: invalid provider "%s"\n' "$runtime_file" "$runtime_line" "$provider" >&2
                    status=1
                fi
            done
        done < "$runtime_file"

        if [ "$runtime_entries" -eq 0 ]; then
            printf 'ERROR %s: no capability rows\n' "$runtime_file" >&2
            status=1
        fi
    fi
done

if [ "$found" -eq 0 ]; then
    printf 'No skills found under %s\n' "$skills_root"
fi

exit "$status"
