---
name: numados-brainstorm
description: Research and structure a development task before planning by reading all decision-relevant supplied sources, inspecting real code and documentation, separating evidence from scope authority, and persisting a compact Obsidian handoff without promoting proposals into requirements. Use when a feature, bug fix, refactor, or integration needs verified context before implementation and no task research record exists yet; route already-recorded open questions or gaps in an existing task record to numados-gap-drill.
---

# Numados Brainstorm

Research the task before any product-source change. Build a durable,
evidence-grounded handoff for planning; do not turn guesses or search output
into requirements.

## Boundary

This skill may update only the task index, compact research note, and one
brainstorm iteration event. It must not modify product source, tests,
configuration, generated code, branches, commits, indexes, or remote systems.

Durable artifacts are Obsidian-backed. Invoke `$numados-obsidian-knowledge`
before reading or writing them. Resolve the vault and task destination through
that skill; never guess a vault or global path. Read the workflow contract when
it is available at `contracts/development-workflow-artifacts.md`.

## Recover first

1. Pass the user's goal, supplied identifiers, URLs, files, repositories, and
   any explicit task destination to the Obsidian skill.
2. Read `_task_index.md` first. If it exists, read only its
   `latest_iteration` next. Follow `research.md` or legacy Mag notes (artifacts
   of the predecessor "Mag" workflow) only when the current question needs
   their detail.
3. If no task index exists, resolve one safe destination and derive a stable
   task slug only when no identifier is available. Ask one smallest question if
   the destination or task identity is ambiguous.
4. Read repository instructions, branch/status, relevant history, and the
   smallest source and documentation slices needed for the task. Establish and
   record the analysed revision and its currency per
   `contracts/working-tree-currency.md`; research recorded against a stale
   checkout becomes a durable handoff that misleads every later phase.
5. Build a supplied-source register for every URL, attachment, comment thread,
   task/epic link, meeting note, and local file explicitly provided by the user
   or directly attached/linked by an authoritative task. Mark each as `Read`,
   `Unavailable`, or `Not decision-relevant` with a reason. Do not conclude or
   declare planning readiness while a decision-relevant supplied source is
   unread; report the exact access gap instead.

## Investigate

Define a bounded search before spending tokens: roots, remote objects, file
types, version/time scope, excluded sensitive areas, and a candidate limit.
Follow [the research method](references/research-method.md) for claim-strength,
requirements traceability, change-surface census, and state/failure analysis.
Its extended retrieval procedure is required when a task spans several
repositories, remote systems, or unfamiliar terminology.
Choose the narrowest verified provider:

- use `$numados-local-search` for local filename, lexical, structural,
  semantic, indexed, and history routing;
- infer a remote provider from the supplied URL and use only an available
  target-applicable reader;
- read authoritative current documentation for version-sensitive behavior;
- verify semantic/indexed candidates against the source document before using
  them as evidence.

Match the evidence to the claim. Source proves code shape; it does not by
itself prove provider behavior, deployed defaults, runtime recovery, or test
feasibility. Verify those claims against the configured version/provider and,
when correctness depends on them, a representative executable check or direct
environment evidence.

Capture only information that changes the implementation decision:

1. authoritative requirements and user decisions, traced to actors, triggers,
   observable outcomes, and constraints without inventing unnamed scenarios;
2. observed current flow and the complete affected contract surface, including
   implementations, test doubles, registration/lifetime/order, persistence,
   operational state, and downstream consumers when applicable;
3. state transitions and material failure points before and after durable or
   externally visible effects, including cancellation, concurrency, recovery,
   health, and logging where relevant;
4. target behavior or decision to make, including explicit API and scope
   boundaries;
5. two or three real options when a choice exists;
6. evidence strength (`Confirmed`, `Inferred`, `Open`) and scope authority
   (`Required`, `Approved`, `Derived safeguard`, `Proposal`, `None`) with
   source paths, headings, lines, or URLs;
7. high-impact open questions with the smallest next check;
8. adjacent pre-existing behavior classified separately from behavior
   introduced, activated, or worsened by the requested change.

Do not copy whole files, remote responses, conversations, or long excerpts.
An absent match means “not found with this route and scope,” not proof of
absence.

Code, provider documentation, historical notes, reviews, and model analysis
may establish current behavior, capability, risk, or a candidate. They do not
authorize feature scope. A derived safeguard must be the minimum internal
property needed to make a Required/Approved behavior safe; if it adds a
technology, stored domain record, public/admin/manual surface, worker, user-visible
restriction, rollout stage, or ongoing operations, keep it as `Proposal` or
`Open` until explicitly approved.

## Write the compact handoff

Through `$numados-obsidian-knowledge`, create or update only:

- `_task_index.md` using `format: numados-task-index-v1`, current status
  `brainstorm`, `latest_iteration`, current state, next action, blocker, and
  links to existing notes;
- `research.md` with only the evidence, current/target behavior, decisions,
  open questions, retrieval limits, and planning handoff that are materially
  useful;
- one immutable `iterations/<sequence>-brainstorm.md` event note using
  `format: numados-task-iteration-v1`.

The event records intent, verified changes/decisions, searches and limits,
verification, completed work, remaining questions, blocker, next action, and
links to `research.md`, the index, and the previous iteration when applicable.
It is one event per meaningful research iteration, not one file per command.
Correct a prior conclusion with a later event; do not rewrite old events.

Do not create `progress.md`, `review.md`, or Mag's multi-file artifact list by
default. Read existing legacy `context/` and `impl-plans/` notes as input and
preserve them. Use the Obsidian skill's post-write re-read, link resolution,
and bounded rediscovery checks.

## Gate and result

Before handing off, confirm that every decision-relevant supplied source is
accounted for, every success condition is represented,
current and target behavior are separate, exhaustive searches support claims
of completeness, material failure/recovery paths are represented, proposed
verification can exercise the claimed behavior, decisions have evidence, open
questions have next checks, and no product file changed. Do not introduce a
new public interface, endpoint, worker, or integration surface without an
explicit requirement or verified consumer.

Run a source-drift lint over `research.md`: enumerate every `must`, `required`,
planned repository/component/data record, provider/fallback, restriction,
manual/admin flow, worker, rollout rule, and acceptance condition. Each must
have Required/Approved authority or be visibly marked Derived safeguard,
Proposal, or Open. Remove unsupported obligations instead of making them sound
necessary.

`READY FOR PLANNING` requires every plan-shaping fact to be `Confirmed` and
every scope-bearing behavior to be `Required`, `Approved`, or a valid minimal
`Derived safeguard`.
An `Open` claim blocks planning when it can change external scope, data
semantics or migration shape, consistency/recovery, component lifetime/order,
security, or verification feasibility. Present a material user decision and
stop, or hand a bounded evidence question to `$numados-gap-drill`; do not
convert it into a planning assumption.

Return:

```text
Status: READY FOR PLANNING | NEEDS INPUT | BLOCKED
Workspace: <vault-relative task workspace>
Latest iteration: <vault-relative event path>
Verified: <key facts and sources>
Open: <questions with impact and next check, or none>
Next: <planning action or exact blocker>
```

The durable notes, not this response, are the handoff source of truth.
