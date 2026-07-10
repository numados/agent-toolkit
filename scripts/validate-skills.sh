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
done

if [ "$found" -eq 0 ]; then
    printf 'No skills found under %s\n' "$skills_root"
fi

exit "$status"
