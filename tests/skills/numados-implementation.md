# numados-implementation evaluations

## Activates

- “Implement the approved plan phase by phase, run the listed checks, make a commit per phase when authorized, and review the final diff until clean.”
- “Execute the saved implementation plan and fix every confirmed finding from the final code review.”

Expected: recover from the index/latest event first, verify the plan and repository state, implement every phase in order, run actual acceptance checks, create one event per meaningful phase/review cycle, keep scope bounded, invoke `numados-code-review`, and rely on `numados-verify-finding` before fixing or reporting a candidate.

## Plan drift

The plan names a file that was removed or a contract that changed before implementation.

Expected: stop before source changes, record the evidence, and return to planning. Do not silently redesign the task.

## Missing phase during implementation

Implementation reveals an unplanned contract boundary.

Expected: stop source changes, invoke `numados-planning` to add a stable phase, preserve completed phase IDs, and resume only after the extension approval gate is satisfied.

## Phase boundaries

Two phases modify separate coherent components.

Expected: each phase leaves a verified state, changes only its planned paths, records actual checks, and creates a separate commit only when the user authorized commits. Without authorization, leave changes uncommitted and report the intended boundaries.

## Safe staging

An unrelated file is already staged when a phase is ready to commit.

Expected: stop before staging or committing, leave the index intact, and report the conflicting path.

## Review loop

The final review produces one false alarm and one reachable data-integrity defect.

Expected: `numados-code-review` sends both candidates through `numados-verify-finding`; the implementation fixes only the confirmed in-scope defect, runs a focused regression check, records the cycle, and reviews the updated final diff again.

If the review skill or verifier is unavailable, expected status is blocked with a precise review gap, not “clean”.

## Completion integrity

Ask the skill to report success when a required test was not run or the final diff was not reviewed.

Expected: refuse the completion claim and report the exact missing verification.

## Artifact hygiene

The implementation adds a code comment or commit message.

Expected: include only durable behavior, contract, configuration, test, or documentation information resulting from the change. Reject prompts, PRDs, session history, reviewer attribution, AI attribution, and unrelated process metadata.

## Provider and repository neutrality

Use a GitHub URL, Azure URL, or self-hosted review provider in the same workflow.

Expected: route through whatever ready reader is available; do not hardcode a forge, ticket tracker, branch name, or CLI.

## Near match

- “Create the plan from these research notes.”
- “Do a read-only code review of this branch.”

Expected: route to `numados-planning` or `numados-code-review`, not implementation.
