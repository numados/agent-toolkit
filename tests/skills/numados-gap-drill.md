# numados-gap-drill evaluations

## Activates

- “Drill the remaining gaps in the plan before implementation; inspect the task notes, repository, docs, and prior knowledge, and ask me only if evidence cannot decide.”
- “Resolve the open contract question from the latest brainstorm using the linked repository and current documentation.”
- “Use `$numados-gap-drill` to stress-test this design and record what is confirmed, inferred, and still open.”

Expected: recover `_task_index.md` and `latest_iteration` through
`numados-obsidian-knowledge`, define bounded gap criteria, search task and
configured knowledge scopes before broader sources, classify evidence, and
write only the compact research correction, index projection, and one
gap-drill event.

## Source and provider routing

Give the skill a GitHub-compatible, Azure-compatible, self-hosted, or ordinary
documentation URL.

Expected: infer the applicable already-available reader from the URL, keep the
workflow provider-neutral, and mark the gap blocked or open when access or
current documentation is unavailable. It must not assume `gh`, `az`, Jira, or
any other specific system.

## Knowledge-store recovery

The task workspace has a configured general knowledge search root and a prior
task with a similar decision.

Expected: search those configured scopes after reading the task index/latest
event, follow only relevant candidates, and cite the prior note as evidence.
If no knowledge root is configured, report the missing coverage rather than
scanning the whole vault.

## Independent challenge and token discipline

The gap is high-impact and ambiguous, and the harness exposes a subagent
provider.

Expected: use bounded independent scout/challenger roles, compare their
structured claims against the sources, use a synthesizer only for the decision,
and stop extra retrieval after the criterion is met. Do not treat model
agreement as proof or dump worker transcripts.

## Discussion fallback

Two authoritative sources conflict on a behavior that changes the plan.

Expected: perform the smallest discriminating checks, then ask one question at
a time with a recommendation, alternatives, trade-offs, and the exact plan
consequence. Resume from the saved state after the answer.

## Plan and safety boundary

The result changes an approved phase and acceptance criterion.

Expected: do not edit `plan.md`, product source, tests, configuration, commits,
or remote state; return `PLAN UPDATE REQUIRED` and hand off to
`numados-planning`. Ordinary gaps do not create `remarks.md`.

## Missing input and near matches

- No task index, latest event, or safe Obsidian destination: stop as
  `NEEDS BRAINSTORM` or request the smallest missing identity/destination.
- “Create the implementation plan from this research”: route to
  `numados-planning`.
- “Implement the approved plan”: route to `numados-implementation`.
- “Review this diff for defects”: route to `numados-code-review`.
