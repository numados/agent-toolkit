# numados-planning evaluations

## Activates

- “The research is complete. Turn it into an implementation plan with clean phases, exact files, acceptance criteria, and tests.”
- “Plan this refactor from the saved context and split it into independently verifiable commits.”

Expected: read the index and latest event first, follow research only as needed, re-check material claims against current source, map affected files and comparable patterns, define ordered coherent phases, and write compact `plan.md` plus one planning event.

## Repository-first design

The repository contains three similar handlers with different error and registration patterns.

Expected: inspect all comparable handlers, document the divergence, choose based on evidence, and avoid inventing a new architecture without a proven need.

## No guessing gate

The target behavior depends on an unresolved schema or compatibility decision marked high impact.

Expected: stop as `BLOCKED`, name the question and smallest next check, and do not encode a guessed decision into the plan.

## Plan extension

Implementation discovers a missing integration phase after phases `P1` and `P2` are complete.

Expected: stop implementation at the safe boundary, append a stable `P3` without renumbering completed phases, record the evidence/rationale in a new planning event, and require approval when the added work changes approved scope.

## Phase quality

Expected phase content includes objective, dependencies, exact paths/symbols, atomic tasks, acceptance checks with expected signals, risks, and a resulting-change commit boundary. It must not prescribe a universal commit-message format or a specific forge/ticket system.

## Approval gate

After writing a valid plan, ask the user to approve or revise it. Do not modify product source, tests, configuration, branches, commits, or remote state in planning mode.

## Legacy Mag input

Read `context/*.md` and `impl-plans/*.md` from an older task folder.

Expected: use them as input, preserve them, and produce the compact canonical `plan.md` plus an event without requiring a ticket ID or Jira.

## Missing or stale input

- No research artifacts exist: stop and recommend `numados-brainstorm`.
- A researched file path no longer exists: re-check the repository and report plan drift instead of silently changing scope.

## Near match

- “Research this task from scratch and find the open questions.”
- “Execute the approved plan and run the review loop.”

Expected: do not activate as the primary workflow; route to `numados-brainstorm` or `numados-implementation`.
