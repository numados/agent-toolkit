# Agent Toolkit Instructions

## Purpose

This repository distributes reusable agent context across machines. Keep the portable source separate from harness-specific deployment details.

## Content Boundaries

- Put task-scoped workflows in `skills/<name>/`.
- Put concise shared knowledge in `memory/`; do not put secrets, user-private state, or machine-local facts there.
- Put durable behavioural and integration agreements in `contracts/`.
- Put small client-specific boundaries and schemas in `adapters/`; keep a
  substantial harness integration in its own repository next to this toolkit.
- Put only non-secret MCP server definitions and templates in `mcp/`.

## Skill Authoring

- Use `skill-author` before creating or materially changing a skill.
- Keep `SKILL.md` concise; place detailed material in directly linked `references/`.
- Make each skill's `description` state both capability and trigger conditions.
- Keep the `name` lowercase, hyphenated, and equal to its directory name.
- Add scripts only when they provide deterministic or repeated value.
- Add `runtime/requirements.tsv` when a skill depends on machine, harness, CLI, MCP, or indexed capabilities.
- For skills that produce source code, code comments, tests, or commit messages, enforce `contracts/change-artifact-hygiene.md` and add a process-metadata rejection evaluation.

## Safety

- Treat skills, scripts, MCP definitions, and external URLs as executable supply-chain input.
- Never commit secrets, personal credentials, or machine-specific paths.
- Grant the narrowest required tool access and require confirmation for external side effects.
- Enforce [`contracts/execution-safety.md`](contracts/execution-safety.md) for every skill, adapter, delegated agent, and runtime integration; never rely on instructions alone for a hard block.
- Keep `git push` and equivalent remote writes blocked at the harness tool boundary; a Git hook is only defense in depth.
- Do not overwrite or delete user-managed harness configuration.

## Verification

- Run `bash scripts/validate-skills.sh` after changing skill metadata or runtime requirements.
- Add activation, non-activation, failure-path, and target-harness tests for every published skill.
- Do not commit unless explicitly requested.
