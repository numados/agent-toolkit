# Development Workflow Artifacts

**Purpose:** Define the small, durable handoff shared by the Numados brainstorm,
gap-drill, planning, implementation, review, and task-question skills.
**Status:** Normative
**Sources:** `skills/numados-brainstorm`, `skills/numados-gap-drill`,
`skills/numados-planning`,
`skills/numados-implementation`, `skills/numados-task-navigator`,
`skills/numados-obsidian-knowledge`

## Scope

These artifacts preserve verified task context across sessions and harnesses.
They are not a replacement for source code, repository instructions, issue
trackers, or the user's decision authority.

Research and planning are compact current documents. They are not transcripts
and must not grow into a dump of search results. The event notes preserve the
meaningful transitions that make the current state recoverable without rereading
all detail.

Use stable task identifiers and vault-relative paths. Keep credentials, session
dumps, private configuration, and machine-specific absolute paths out of
portable notes.

## Storage and workspace resolution

The workflow is Obsidian-backed. Before reading or writing task artifacts, invoke
`$numados-obsidian-knowledge` to resolve the vault, project profile, write root,
and existing neighboring conventions. Do not guess a vault, global path, or
folder taxonomy.

Resolve one task workspace using this precedence:

1. An explicit task-workspace or destination supplied by the user.
2. An existing task index discovered through the configured Obsidian profile.
3. An existing legacy Mag workspace containing `_task_index.md` plus `context/`
   or `impl-plans/`; read it without rewriting the raw artifacts.
4. A configured Numados write root plus a derived task slug, when no existing
   workspace or neighboring convention is available.
5. Ask for the smallest missing path/profile detail if more than one location
   is plausible or no safe configured destination exists.

For a workflow task, a typical layout is:

```text
<task-workspace>/
├── _task_index.md
├── research.md
├── plan.md
├── remarks.md                 # only when remarks/findings exist
└── iterations/
    ├── 0001-brainstorm.md
    ├── 0002-planning.md
    └── 0003-implementation-p1.md
```

Preserve an existing vault convention when it differs. The `iterations/`
directory and filenames are the default only when the destination is new.

## Canonical artifacts

### `_task_index.md`

This is a tiny materialized current-state projection. It is the first file an
agent reads and should normally fit in one short screen. Use:

```yaml
---
format: numados-task-index-v1
task_id: <stable-id-or-derived-slug>
title: <short task title>
status: brainstorm | planning | implementing | reviewing | blocked | done
repository: <repository name or relative path>
current_phase: <phase id or none>
latest_iteration: iterations/0003-implementation-p1.md
created: 2026-07-13
updated: 2026-07-13
---
```

Below the frontmatter include only:

- `Current state:` one or two factual lines;
- `Next:` the next action or approval;
- `Blocker:` a named blocker or `none`;
- links to `research.md`, `plan.md`, and `remarks.md` only when they exist;
- the relative path in `latest_iteration`.

Update the projection after every meaningful workflow iteration. Do not put the
full history, search transcript, or review discussion in this file.

### `research.md`

The current, concise research handoff contains only information needed to make
or revisit the planning decision. Use the following sections when applicable:

- Goal and success definition
- Scope and constraints
- Evidence table: claim, `Confirmed`/`Inferred`/`Open`, source, consequence
- Current behavior and affected flow
- Target behavior or decision
- Options and trade-offs
- Decisions
- Open questions with impact and next check
- Sources and retrieval limits
- Handoff to planning

Keep excerpts out of the note when a path, heading, line, or URL is sufficient.
Update the current note when new evidence changes the conclusion; record the
meaningful change in a new iteration event.

### `plan.md`

The current approved or proposed plan contains:

- goal, architecture, and boundaries;
- existing patterns to preserve and new boundaries to introduce;
- file and contract map;
- ordered phases with stable IDs, dependencies, files, acceptance, checks,
  risks, and commit boundaries;
- final verification and review scope;
- handoff to implementation.

Do not encode a universal commit-message format. A plan may describe the
resulting change in a phase commit, while `$numados-commit-message` handles
repository-specific message text later.

### `remarks.md`

Keep review findings, rejected candidates, unresolved remarks, and their
resolutions in a separate file so they do not pollute the research or plan.
Create it only when remarks exist. Each remark should have a stable ID, status,
evidence, affected path or contract, and resolution/next check. Preserve
resolved remarks; do not rewrite them away.

### `iterations/<sequence>-<stage>[-phase].md`

Each meaningful workflow iteration creates one event note. An iteration is a
research pass, plan revision, implementation phase, review cycle, or correction
that changes the task state; it is not one file per shell command or tool call.
Event notes are append-only: correct a prior conclusion by creating a later
event, never by rewriting the old event.

Use this frontmatter:

```yaml
---
format: numados-task-iteration-v1
task_id: <same task id as _task_index.md>
iteration: "0003"
stage: brainstorm | gap-drill | planning | implementation | review
status: active | ready | blocked | done
previous: iterations/0002-planning.md
created: 2026-07-13
---
```

Keep the body compact:

```markdown
# Iteration 0003 — implementation / phase-1

## Intent
<what this iteration was meant to establish or change>

## Verified state
- <material evidence, decision, or correction>

## Changes
- Source/artifacts: <bounded paths>
- Commits: <hashes, or not created>

## Verification
- <actual command/result or explicit limitation>

## Handoff
- Completed: <short list>
- Remaining: <short list>
- Blocker: <none or exact blocker>
- Next: <next action>

## Detail
- [[research]]
- [[plan]]
- [[remarks]]
- [[0002-planning]]
```

Include only links that exist and use the vault's configured link style. Link to
detail instead of copying it into the event. The index points to the newest
event, while `previous` gives the event chain.

## Recovery and write protocol

The default read order is deliberately bounded:

1. Read `_task_index.md`.
2. Read the note at `latest_iteration`.
3. Follow only the linked `research.md`, `plan.md`, `remarks.md`, source, or
   older iteration needed to answer the current question or perform the next
   action.

A workflow skill must not reread every artifact by default. After writing an
`research.md`, `plan.md`, `remarks.md`, or iteration note, the Obsidian skill
must re-read the changed notes, resolve added internal links, and verify that a
bounded search can find the new state.

When an older Numados workspace uses `_task_index.md` with
`format: numados-development-v1`, treat it as a readable legacy projection and
migrate only the minimum useful state into `numados-task-index-v1` plus a new
iteration event. When a legacy Mag workspace exists, read these locations as
input:

| Legacy artifact | Canonical use |
|---|---|
| `context/research-summary.md` | goal, scope, evidence, success definition |
| `context/current-behavior.md` | current behavior and flow |
| `context/target-behavior.md` | target behavior and acceptance |
| `context/open-questions.md` | open questions and blockers |
| `context/repo-mapping.md` | file and dependency map |
| `impl-plans/coding-phases.md` | plan phases |
| `impl-plans/test-strategy.md` | verification strategy |
| `impl-plans/checklist.md` | progress/checklist |
| `impl-plans/changelog.md` | change history |

Do not create the legacy file list by default. Migrate only the minimum useful
content into the current `research.md` or `plan.md`, then record the migration
as an iteration event. Existing `progress.md` and `review.md` remain readable
for compatibility but are not created by the Numados workflow unless the user
explicitly asks for them.

## Evidence and decision rules

Classify every material claim:

- **Confirmed** — directly observed in source, tests, configuration, an
  artifact, or an authoritative current document; cite a path and line/heading
  or a direct URL.
- **Inferred** — derived from named evidence; state the reasoning and do not
  present it as a fact.
- **Open** — unresolved; record impact, confidence, and the smallest next check
  or person who can answer it.

Never turn a missing tool result, absent search match, stale artifact, or model
recollection into a confirmed fact. Re-check material evidence before planning
and again when implementation starts if the repository or external source may
have changed.

## State gates and plan extension

- `brainstorm` may update only the compact research projection, task index, and
  one brainstorm iteration event. It must not modify product source, tests,
  configuration, or commits.
- `gap-drill` may read local and remote evidence and update only the compact
  research projection, task index, and one gap-drill iteration event. It must
  not edit `plan.md`, product source, tests, configuration, commits, or remote
  state. If its conclusion changes the approved plan, it hands off to
  `$numados-planning` for a recorded extension or correction.
- `planning` requires enough verified research to make a design decision. It
  may update the current plan, index, and one planning iteration event.
- `implementation` requires an approved plan and a understood working-tree
  scope. It may update source and create one event per meaningful phase or
  review/fix cycle.
- If implementation discovers work not represented by the plan, it stops source
  changes and invokes `$numados-planning`. Planning adds stable phase IDs
  without renumbering completed phases. A new phase that changes approved scope
  requires user approval; a phase that only decomposes already-approved behavior
  records its evidence and rationale in the planning event.
- Review continues until no confirmed actionable finding remains or a named
  blocker needs user input. Findings and resolutions go to `remarks.md` and the
  corresponding review event.

## Artifact hygiene

Apply [`change-artifact-hygiene.md`](change-artifact-hygiene.md) to source,
comments, tests, generated change descriptions, and commit messages. Workflow
artifacts may record development progress, decisions, and review findings
because that is their explicit purpose; do not copy that process metadata into
maintained code or unrelated commits.
