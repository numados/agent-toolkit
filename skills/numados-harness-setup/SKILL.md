---
name: numados-harness-setup
description: Discover, preview, apply, verify, and roll back Numados skills and harness configuration for the currently running AI harness. Use when installing Numados on a machine, project, or harness, when native instruction/config paths are unclear, or when a setup must prove discovery and context precedence before changing files.
---

# Numados Harness Setup

Configure the harness that is executing this skill. This is one guarded
workflow, not a replacement for `numados-brainstorm`, `numados-planning`, or
`numados-implementation`.

## Operating rules

- Do not assume the harness, config path, instruction filename, scope, or
  precedence. Use native diagnostics and current official documentation first;
  ask one targeted question when they cannot prove it.
- Default to the active harness only. A different harness requires an explicit
  target from the user.
- Keep discovery, plan, apply, verify, and rollback distinct. `apply` requires
  an explicit confirmation after the complete plan is shown.
- Generic skill installation may deploy skill directories, but the
  harness-specific adapter owns native settings, environment declarations,
  instruction projections, backups, atomic writes, and config parsing. If no
  adapter is available, stop instead of editing guessed files.
- Skill-owned parameters are configured through that skill's documented
  configurator, not written as guessed harness environment entries. Include
  delegated changes in the same preview, confirmation, verification, and
  rollback plan.
- Never print or copy secret values, tokens, credentials, or auth state. Inspect
  only safe names/presence and preserve user-managed configuration.
- Project/company context and managed policy take precedence over Numados base
  context. Report provenance and conflicts; if the harness cannot prove the
  result, return `UNKNOWN PRECEDENCE`.

## Workflow

1. **Discover**: identify the active harness and version; determine project,
   user, and managed scopes; locate the effective `AGENTS.md`, `CLAUDE.md`,
   native config, skills, settings, environment declarations, and adapter.
   Record paths, source ownership, safe presence/version facts, and installed
   skills whose required profile parameters are unresolved.
2. **Plan**: show exact targets and intended operations (`add`, `update`,
   `preserve`, `shadow`, or `skip`), including managed blocks, settings
   overlays, environment variable names, precedence conflicts, backups, and
   rollback paths. Do not mutate anything.
3. **Apply**: only after the user explicitly confirms the displayed plan.
   Delegate to the adapter; use idempotent marked blocks and overlays, never
   overwrite unrelated content, and never authenticate or push remotely.
4. **Verify**: run native config parsing/diagnostics, confirm native skill
   discovery, inspect the effective instruction/settings sources, validate the
   managed contract link, and re-check precedence and safety for this harness.
5. **Rollback**: on request or failed verification, restore only the setup
   backup through the adapter, then verify the pre-setup state. Do not delete
   user changes made after the backup.

## Required result

Return a compact report:

```text
Status: READY | NEEDS INPUT | APPLIED | BLOCKED | UNKNOWN PRECEDENCE
Harness: <name and version>
Scope: <project | user | managed>
Sources: <effective, shadowed, and ownership>
Changes: <paths/settings/env names; no secret values>
Verification: <native checks and result>
Backup: <path or none>
Rollback: <adapter action>
Next: <exact confirmation, question, or action>
```

Read [setup policy](references/setup-policy.md) for the adapter boundary,
managed instruction projection, scope selection, and failure handling.
