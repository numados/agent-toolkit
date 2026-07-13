# Numados Task Iterations

Use this protocol only for the Numados development workflow. It keeps task
state recoverable while avoiding a transcript or a large generated artifact
tree.

## Read order

1. Resolve the vault/profile and the task workspace through the normal Obsidian
   context rules.
2. Read `_task_index.md`. Confirm `format: numados-task-index-v1` before using
   its routing fields. An older `numados-development-v1` index is readable
   legacy input; do not assume its links are current.
3. Read the relative `latest_iteration` note and confirm
   `format: numados-task-iteration-v1`, `task_id`, and `previous`.
4. Follow only the links needed for the current question or action. Prefer the
   current `research.md`, `plan.md`, and `remarks.md`; follow older events when
   the latest event explicitly leaves a decision or blocker unresolved.

If the index or latest event is missing, search only the task workspace for
matching filenames/frontmatter. Report the recovery gap; do not scan or infer
from the whole vault.

## Compact write model

`research.md` and `plan.md` are editable current projections. Keep only
decision-relevant evidence, decisions, phase state, acceptance, and open
questions. Long source excerpts belong in the source itself; link to a path,
heading, line, or URL.

`remarks.md` is a separate current view of review findings and resolutions. It
is created only when a remark exists and keeps stable IDs so later events can
refer to it.

Each meaningful iteration gets one new note under `iterations/`:

```yaml
---
format: numados-task-iteration-v1
task_id: <stable task id>
iteration: "0001"
stage: brainstorm | planning | implementation | review
status: active | ready | blocked | done
previous: iterations/0000-<stage>.md
created: YYYY-MM-DD
---
```

The body should contain only `Intent`, `Verified state`, `Changes`,
`Verification`, and `Handoff` sections, followed by links to detail notes when
needed. A correction creates a later event; old event notes are not rewritten.
Use a monotonically increasing zero-padded sequence. Do not make a new event for
every search query, shell command, or unchanged observation.

## Index update

After writing an event, update `_task_index.md` as a projection:

- status and current phase;
- `latest_iteration` path;
- updated date;
- one short current-state line;
- next action and blocker;
- links to existing `research.md`, `plan.md`, and `remarks.md`.

Do not copy event history into the index. Preserve existing property names and
link syntax outside the required Numados fields.

## Verification

After each write:

1. re-read the changed note(s);
2. validate frontmatter and task ID/sequence consistency;
3. resolve every new internal link;
4. search the task workspace with a bounded filename or exact-property query;
5. report the exact vault-relative paths changed.

If the destination is ambiguous, stop before writing. If a legacy Mag workspace
exists, read it as input and migrate only the minimum useful content into the
current projections plus one migration event.
