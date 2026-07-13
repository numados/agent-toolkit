---
name: numados-implementation
description: Execute an approved Numados plan phase by phase, verify the real result, log each meaningful phase and review iteration in Obsidian, extend the plan when evidence requires it, and repeat validated review/fix cycles until clean or precisely blocked. Use when implementing a planned feature, bug fix, refactor, migration, or integration.
---

# Numados Implementation

Execute the approved plan against the real repository. Verify before deciding,
keep phase boundaries clean, and never declare completion from an unrun check or
an unverified review hypothesis.

## Authority and recovery

This skill may modify product source, tests, configuration, generated files,
and workflow artifacts inside the approved scope. It must not push, post remote
comments, merge, deploy, install tools, switch branches, or change unrelated
staged work without separate explicit authority.

Before source changes, read `references/review-loop.md` and, when available,
`contracts/development-workflow-artifacts.md`.

Durable workflow notes are Obsidian-backed. Invoke
`$numados-obsidian-knowledge` first and recover in this order:

1. `_task_index.md`;
2. its `latest_iteration` event;
3. the current `plan.md`;
4. `research.md`, `remarks.md`, older iterations, and legacy Mag artifacts only
   when the plan or current question requires them.

Require an approved current plan, a known source scope, and a safe working-tree
baseline. Re-check plan assumptions against current source, configuration,
dependencies, and authoritative documentation. If they drift, stop and invoke
`$numados-planning` before making an unplanned source change.

## Execute phases

For each incomplete stable phase, in plan order:

1. verify dependencies and restate the phase objective;
2. inspect analogous code, tests, configuration, and current documentation;
3. implement the complete phase without placeholders or speculative cleanup;
4. run the exact acceptance checks and diagnose failures from their output;
5. inspect the bounded diff, contracts, edge paths, compatibility, and tests;
6. commit only when the user or active repository instructions authorize it;
7. through `$numados-obsidian-knowledge`, create one immutable
   `iterations/<sequence>-implementation[-phase].md` event with changed paths,
   actual checks, commit hash (if any), completed state, remaining work,
   blockers, next action, and links to `plan.md`, `research.md`, `remarks.md`,
   and the previous event; update `_task_index.md`.

Use `$numados-commit-message` only to generate repository-aligned text; it does
not stage or commit. Stage only verified phase paths and stop when unrelated
paths are already staged.

### When the plan is insufficient

If implementation reveals work not represented by the approved plan, stop at a
safe boundary before implementing it. Record the evidence in the current
iteration event, invoke `$numados-planning`, and resume only after the added
phase is recorded and approved when required. Do not silently broaden scope or
renumber completed phases.

## Review and correction loop

After planned phases pass:

1. set task status to `reviewing` in the index;
2. invoke `$numados-code-review` as a read-only review; it must validate every
   candidate with `$numados-verify-finding`;
3. put findings, rejected candidates, evidence, and resolutions in the
   separate `remarks.md` through the Obsidian skill;
4. create one immutable review event for each review cycle and each corrective
   implementation cycle;
5. fix only confirmed in-scope blockers/issues, run focused regression checks,
   and commit only when authorized;
6. review the updated final diff again.

Continue until the final review says `No actionable findings.` and all required
verification passes. If review or evidence is unavailable, or a finding needs
a product decision, mark the task blocked with the exact missing evidence or
decision. Do not report a clean result from raw hypotheses.

## Closeout

Use the Obsidian skill to re-read changed notes, resolve internal links, and
verify bounded rediscovery. Set `_task_index.md` to `done` only after all
phases, verification, and the final review are complete. Keep `remarks.md`
separate from the plan and research. Do not create `progress.md` or
`review.md` by default; existing legacy files remain readable.

Return:

```text
Status: DONE | BLOCKED | CHANGES READY FOR COMMIT
Workspace: <vault-relative task workspace>
Latest iteration: <vault-relative event path>
Phases: <completed phases and any added/skipped phase>
Verification: <actual checks and material limits>
Review: <cycle count and final verdict>
Remarks: <remarks path, or none>
Commits: <hashes, or not created>
Blocker: <exact missing evidence/decision, or none>
Next: <user action only when needed>
```
