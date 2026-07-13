# Implementation Review Loop

## Scope snapshot

Before the first review, capture in the review event:

- repository and branch as read-only metadata;
- base and head commits, or the exact bounded diff;
- planned files and actual changed files;
- verification commands already run and their results;
- any unrelated staged path that prevents safe staging.

Review the final state, not an earlier phase snapshot. If the source is remote,
use the provider selected for the task and request the complete changed content.

## Finding lifecycle

Treat a review candidate as a hypothesis:

1. state the contract it might violate;
2. trace a reachable input through changed code, guards, state transitions, and
   consumers;
3. verify configuration, framework, serializer, version, and deployment
   assumptions from source or current documentation;
4. classify it with `$numados-verify-finding`;
5. write the candidate and verdict to `remarks.md`, including evidence and the
   next action;
6. fix only `Confirmed Blocker` or `Confirmed Issue` findings that are in
   scope;
7. run a focused regression check and create a new review/fix event.

Do not turn missing evidence into a false alarm. Do not turn a pre-existing,
unactivated defect into a finding. Do not add generic test or style work to the
review loop.

## Event and remarks rule

Each review pass and each corrective implementation pass gets one immutable
event note. The event links to the current `plan.md`, `remarks.md`, the prior
event, and the bounded diff. `_task_index.md` points to the newest event.
`remarks.md` is the durable finding view; it is separate from research and the
plan. A clean review may omit the file and records `No actionable findings.`
in the event.

## Safe phase commits

Before staging:

1. inspect `git status --short` and the staged diff;
2. stop if unrelated staged paths exist or if the phase changed an unplanned
   path;
3. stage only verified phase paths;
4. inspect the staged diff and run phase checks;
5. use `$numados-commit-message` only to derive repository-aligned text; it
   does not stage or commit;
6. create a commit only under explicit authority and record its hash in the
   event.

Commit content describes the resulting software, test, configuration, or
documentation change. Do not include prompts, PRDs, review process, session
history, or AI attribution.

## Stop conditions

Stop and mark the task `blocked` when a plan assumption is contradicted by
current code or documentation, required evidence/provider/credentials are
unavailable, verification cannot be resolved, a confirmed finding needs an
ambiguous product decision, or unrelated staged/remote state would be changed.

State the exact evidence and smallest user action needed. Never continue by
substituting a plausible implementation.
