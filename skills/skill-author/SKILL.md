---
name: skill-author
description: Create, update, or review reusable Agent Skills. Use when defining a new SKILL.md, improving an existing skill, deciding whether a workflow should be a skill, or checking a skill for activation, safety, portability, and evaluation gaps.
---

# Skill Author

## Scope

Create task-scoped skills that work as portable core content and expose target-specific details through adapters. Do not use this skill to create always-on repository instructions or a distinct agent role without first classifying the requested context.

## Procedure

1. Identify the requested outcome and write two realistic user prompts that should trigger it.
2. Classify the request:
   - Use a skill for an on-demand, repeatable workflow.
   - Use an instruction for a broad, always-applicable rule or baseline memory.
   - Use an agent for a separate role with its own authority or tool boundary.
3. Inspect repository instructions and the target harness scope before choosing files or frontmatter beyond `name` and `description`.
4. Define the skill contract: inputs, preconditions, procedure, output format, verification, and safe stop conditions.
5. Keep the main workflow in `SKILL.md`. Move detailed policies, variants, and examples into directly linked files in `references/`.
6. Add scripts only for deterministic or repetitive work. Document their inputs, outputs, dependencies, permissions, and failure behaviour.
7. Run `bash scripts/validate-skills.sh` from the repository root after editing metadata.
8. Evaluate positive activation, near-match/non-activation, missing-input, and failure-path prompts before publishing.

## Constraints

- Keep the skill name lowercase, hyphenated, and equal to its directory name.
- Make the description state both capability and trigger conditions; it is the primary routing signal.
- Keep portable content independent of a specific client tool, hook, plugin, or MCP schema.
- Treat scripts, URLs, and MCP dependencies as untrusted until reviewed.
- Never include secrets, hidden side effects, or unrestricted tool access by default.

## Review

Use the [quality rubric](./references/quality-rubric.md) before approving a new or materially changed skill. Report unresolved compatibility or security concerns rather than silently assuming them away.
