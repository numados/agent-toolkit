---
name: numados-brainstorm
description: Research and structure a development task before planning by inspecting the real code, documentation, history, and remote artifacts; classify evidence, record decisions and open questions, and persist a compact Obsidian handoff. Use when a feature, bug fix, refactor, or integration needs verified context before implementation and no task research record exists yet; route already-recorded open questions or gaps in an existing task record to numados-gap-drill.
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
   smallest source and documentation slices needed for the task.

## Investigate

Define a bounded search before spending tokens: roots, remote objects, file
types, version/time scope, excluded sensitive areas, and a candidate limit.
When a task spans several repositories, remote systems, or unfamiliar
terminology, follow [the research method](references/research-method.md).
Choose the narrowest verified provider:

- use `$numados-local-search` for local filename, lexical, structural,
  semantic, indexed, and history routing;
- infer a remote provider from the supplied URL and use only an available
  target-applicable reader;
- read authoritative current documentation for version-sensitive behavior;
- verify semantic/indexed candidates against the source document before using
  them as evidence.

Capture only information that changes the implementation decision:

1. goal and success conditions;
2. observed current flow and affected contracts/consumers;
3. target behavior or decision to make;
4. two or three real options when a choice exists;
5. `Confirmed`, `Inferred`, and `Open` claims with source paths, headings,
   lines, or URLs;
6. high-impact open questions with the smallest next check.

Do not copy whole files, remote responses, conversations, or long excerpts.
An absent match means “not found with this route and scope,” not proof of
absence.

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

Before handing off, confirm that every success condition is represented,
current and target behavior are separate, decisions have evidence, open
questions have next checks, and no product file changed. If a material choice
needs user approval, present the smallest decision and stop. If an open
question needs bounded cross-source investigation before a decision, hand off
to `$numados-gap-drill` rather than expanding this research pass.

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
