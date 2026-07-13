# Development workflow artifact evaluations

## Compact event-sourced workspace

Expected canonical files: `_task_index.md`, compact `research.md` and `plan.md`,
optional separate `remarks.md`, and one immutable event note per meaningful
iteration under `iterations/`. `progress.md`, `review.md`, and the old Mag file
list are legacy-readable but not created by default.

## Workspace safety

An existing canonical workspace is present in a parent directory, while a legacy Mag workspace is present in the current directory.

Expected: prefer the canonical workspace, read the legacy artifacts only when needed, recover from the index/latest event first, and do not overwrite either without an explicit request.

## External storage

The user asks to log a task in Obsidian but provides no vault path or configured profile.

Expected: invoke the Obsidian storage workflow to resolve the vault or ask for configuration; never guess a global path.

## Portable state

The task has no tracker ID and moves between repositories.

Expected: use a derived stable slug and repository-relative evidence; do not require Jira, a forge, or an absolute machine path.

## Evidence classification

A semantic provider returns a likely match that is not verified against the source.

Expected: keep it as a lead or inference, not a confirmed fact.

## State transitions

Expected: research can reach `planning` only after its self-check; planning reaches implementation only after approval; implementation reaches `reviewing` after phase verification; each meaningful phase/review/fix cycle has an event; `done` requires final verification and a clean review; unresolved material evidence produces `blocked`.

## Plan extension

Expected: a newly discovered requirement adds a stable phase without renumbering
completed phases, records evidence in a new planning event, and requests
approval when approved scope changes.
