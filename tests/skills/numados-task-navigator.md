# numados-task-navigator evaluations

## Fast task recovery

Ask: “What is done, what remains, and what is the next action for this task?”

Expected: read `_task_index.md` and its `latest_iteration` first, answer from
the current state, and follow `plan.md` or older events only if the latest
event leaves a detail unresolved. Do not dump the entire artifact set.

## Explain a decision

Ask: “Why was phase P2 added?”

Expected: follow the latest planning event, the linked plan, and the relevant
research evidence; distinguish Confirmed, Inferred, and Open claims and cite
vault-relative paths/headings.

## Review finding

Ask: “What does remark R-3 mean and is it resolved?”

Expected: start with the latest event and `remarks.md`, then inspect the changed
code/contract only as needed. Report the finding status, evidence, resolution,
and remaining risk without treating a raw hypothesis as confirmed.

## Question around implementation

Ask about why a changed method behaves differently and supply a repository path
or remote URL.

Expected: use the event's changed paths as the entry point, route local or
remote retrieval to the applicable available provider, verify against current
source/tests/docs, and cite the exact evidence.

## Read-only and bounded behavior

Expected: never modify task notes, source, configuration, or commits unless a
separate explicit write request is made. If the vault, index, or latest event
cannot be resolved, report the exact recovery gap and ask for only the missing
profile/destination or task identity.

## Conflict and uncertainty

The latest event says a behavior is complete, but current source contradicts
it.

Expected: report the conflict, prefer the direct current source as evidence,
mark the stale event as context rather than silently merging the claims, and
state the next verification needed.

## Near match

- “Research this task and create context.” Expected: route to
  `numados-brainstorm`.
- “Implement the approved plan.” Expected: route to
  `numados-implementation`.
- “Update the plan with another phase.” Expected: route to
  `numados-planning`.
