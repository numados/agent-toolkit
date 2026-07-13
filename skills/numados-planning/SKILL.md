---
name: numados-planning
description: Turn verified task research into a repository-aligned implementation plan with explicit architecture, stable phases, acceptance criteria, verification, and review handoff. Use after brainstorm context exists or when an implementation discovers that the current plan needs an evidence-based phase extension.
---

# Numados Planning

Convert verified evidence into an executable plan. A plan is a current design
contract, not a place to invent missing requirements or produce a checklist of
trivial files.

## Boundary and recovery

This skill may read the repository and update only the task index, compact
`research.md`/`plan.md` projections, and one planning iteration event. It must
not modify product source, tests, configuration, generated code, branches,
commits, or remote systems.

Durable artifacts are Obsidian-backed. Invoke `$numados-obsidian-knowledge`
before reading or writing them. Read
`contracts/development-workflow-artifacts.md` when it is available.

Recover in this order:

1. resolve the configured Obsidian workspace;
2. read `_task_index.md`;
3. read only `latest_iteration`;
4. follow `research.md`, `plan.md`, `remarks.md`, legacy Mag notes, or older
   iterations only when needed for the current decision.

Require enough verified research to identify the goal, current behavior, target
behavior, affected contracts/files, and verification scope. If a high-impact
question is unresolved, stop with its impact and smallest discriminating check.

## Build or extend the plan

Re-check material research claims against current repository instructions,
source, configuration, dependencies, and current documentation. Map the file
and contract surface before choosing a design. Inspect comparable code and
tests; preserve existing patterns and use best practices only for genuinely
new boundaries or a proven compatibility need.

The current `plan.md` contains only the executable design:

- goal, architecture, and boundaries;
- patterns to preserve and deliberate divergences;
- file and contract map;
- ordered phases with stable IDs, dependencies, exact paths/symbols,
  acceptance criteria, checks, risks, recovery, and resulting-change commit
  boundaries;
- whole-change verification and final review scope;
- implementation handoff.

Each phase must be a coherent, independently verifiable increment. Keep the
number of phases small and meaningful.

### Evidence-based phase extension

When implementation or a later investigation shows that the current plan is
insufficient:

1. stop source changes at the discovered boundary;
2. state the concrete evidence and why the existing phases cannot satisfy it;
3. append new stable phase IDs to `plan.md` without renumbering or rewriting
   completed phases;
4. give each added phase dependencies, exact files/contracts, acceptance,
   verification, risk, and a commit boundary;
5. record the previous plan event, evidence, and rationale in a new planning
   iteration event;
6. require user approval when the added phase changes approved behavior,
   external scope, data contracts, or material risk. If it only decomposes
   already-approved behavior, record that fact and continue under the existing
   approval.

Never silently add a phase or use a new phase to hide an unverified assumption.

## Write the handoff

Through `$numados-obsidian-knowledge`, update:

- `_task_index.md` with status `planning`, current phase/next action,
  `latest_iteration`, blocker, and links to existing notes;
- the current compact `plan.md` (and `research.md` only if a verified research
  correction is necessary);
- one immutable `iterations/<sequence>-planning.md` event note.

The event records whether this was a new plan or extension, verified evidence,
phase changes, approval state, checks, remaining blockers, and links to the
index, research, plan, remarks when present, and the previous event.

Do not create `progress.md`, `review.md`, or the legacy Mag artifact list by
default. Preserve legacy files and use them as read-only input. After writing,
use the Obsidian skill's re-read, link-resolution, and bounded rediscovery
checks.

## Self-review and gate

Trace every success condition to a phase and acceptance check. Verify names,
paths, dependencies, phase order, current patterns, version constraints, and
external APIs. Remove placeholders and vague tasks. Make every remaining
inference or open question visible with its validation step.

Do not start implementation automatically. Ask for approval or revision unless
the caller explicitly supplied approval for this plan/extension.

Return:

```text
Status: PLAN READY | NEEDS INPUT | BLOCKED
Workspace: <vault-relative task workspace>
Latest iteration: <vault-relative event path>
Plan: <vault-relative plan path>
Phases: <count and short names; identify added phases>
Verification: <key checks>
Open: <remaining non-blocking questions, or none>
Next: <approval, implementation, or exact blocker>
```
