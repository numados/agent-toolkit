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
behavior, affected contracts/files, and verification scope. Confirm that the
research and the file boundaries were established on a current revision per
`contracts/working-tree-currency.md`; plan phases built on a stale reading of
the code produce file boundaries and acceptance criteria that do not match
reality. If a gap-drill
event reports a material plan impact, incorporate its verified conclusion
before changing the plan; do not treat an unresolved gap as an approved design.
If a high-impact question is unresolved, stop with its impact and smallest
discriminating check. If the research base itself is missing or too thin to
plan from, stop and recommend `$numados-brainstorm` instead of inventing
requirements.

## Build or extend the plan

Re-check material research claims against current repository instructions,
source, configuration, dependencies, and current documentation. Map the file
and contract surface before choosing a design. Inspect comparable code and
tests; preserve existing patterns and use best practices only for genuinely
new boundaries or a proven compatibility need.

Follow [phase design](references/phase-design.md) for evidence-to-plan
traceability, the complete change-surface census, failure-state design,
provider-realistic verification, phase right-sizing, extension rules, and
commit boundaries.

Before assigning phases, prove plan readiness:

- trace every authoritative requirement and explicit user decision to a
  scenario, planned behavior, acceptance signal, and verification;
- re-run exhaustive searches for every changed contract or symbol, including
  implementers, test doubles, registration/lifetime/order, persistence and
  operational consumers;
- trace state and ownership across validation, durable/external effects,
  post-effect work, cancellation, concurrency, restart, and recovery;
- verify that the selected test seam and provider can exercise each claimed
  behavior.

Do not introduce a public API, administrative endpoint, worker, data contract,
or service-to-service surface merely because it may be useful later. Require an
approved requirement or verified current consumer. Keep pre-existing,
unaffected defects outside the implementation scope unless the user explicitly
adds them.

Treat framework/provider behavior, migration shape, deployed defaults, data
comparison semantics, and external contracts as facts only when the evidence
can prove them. A plan may contain a named verification gate for a
non-blocking uncertainty, but it must not prescribe an unverified fallback or
manual recovery as if it were known-correct.

The current `plan.md` contains only the executable design:

- goal, architecture, and boundaries;
- patterns to preserve and deliberate divergences;
- requirement traceability plus the complete file and contract map;
- relevant state/failure outcomes and recovery ownership;
- ordered phases with stable IDs, dependencies, exact paths/symbols,
  acceptance criteria, checks, risks, recovery, and resulting-change commit
  boundaries;
- whole-change verification and final review scope;
- implementation handoff.

Each phase must be a coherent, independently verifiable increment. Keep the
number of phases small and meaningful.

When phases introduce or change business behaviour, invoke `$numados-tdd` in
planning mode to extend each phase with seams under test, a business-rule test
list, and verification commands. Skip it only for phases with no behavioural
surface (pure configuration, generated code) and record that decision.

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

Trace every authoritative success condition to a phase and acceptance check;
keep derived engineering safeguards distinguishable from product acceptance.
Verify names, paths, every implementation/test double, dependencies,
registration order and lifetimes, phase order, current patterns, version and
provider constraints, persistence/index semantics, and external APIs.

Challenge the plan at every irreversible boundary: what happens if the next
step fails, cancellation arrives, a concurrent operation completes out of
order, or the process restarts? Require a convergence/recovery owner and an
observable health/logging outcome when correctness can become stale or
ambiguous. For a handled persistence or external failure in a reused lifetime,
require cleanup/reset behavior and a subsequent-operation test when applicable.

Confirm that each automated check uses a provider and fixture capable of the
feature under test; use representative integration verification for
provider-specific query, migration, constraint, transaction, or error behavior.
Remove placeholders, speculative fallbacks, and vague tasks. Make every
remaining inference or open question visible with its validation step, and
block approval when it can materially change the design or make verification
invalid.

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
