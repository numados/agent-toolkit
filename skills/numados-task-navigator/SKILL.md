---
name: numados-task-navigator
description: Answer questions about a development task from its compact Obsidian state, starting with the task index and latest iteration event, then following linked research, plan, remarks, source, documentation, remote artifacts, or history only as needed. Use when the user asks what happened, why it was decided, what remains, what a finding means, or any related question around an active or completed task.
---

# Numados Task Navigator

Provide a precise, first-read-understandable answer about a task without making
the user reread its entire artifact set. This is read-only by default.

## Recovery-first workflow

Use `$numados-obsidian-knowledge` to resolve the configured vault and task
workspace. Then follow [question routing](references/question-routing.md):

1. Read `_task_index.md`.
2. Read only the event at `latest_iteration`.
3. Decide whether the question is answered by the current state.
4. Follow linked `research.md`, `plan.md`, `remarks.md`, or older iteration
   events only when a detail, decision, finding, or history is missing.
5. For questions about implementation, inspect the cited source and tests. For
   a remote URL, infer the provider from the URL and use an already available
   applicable reader. For version-sensitive behavior, read current authoritative
   documentation. Use `$numados-local-search` for bounded local retrieval.

Do not read every artifact by default, dump a vault, or repeat long excerpts.
Stop once the answer has enough evidence; expand the search only when the next
source can change the answer.

## Answer contract

Answer the user's actual question first. Use a compact structure appropriate to
the question, normally:

```text
Answer: <direct conclusion in one or two sentences>

Why / evidence:
- Confirmed: <claim> — <vault-relative note path + heading, source path/line, or URL>
- Inferred: <reasoning> — <evidence>
- Open: <unknown and why it matters>, if any

State: <done / remaining / blocker / next action, when relevant>
```

Use `Confirmed` only for directly observed evidence, `Inferred` for reasoning
over named evidence, and `Open` when the available material cannot decide.
Prefer the newest iteration and current projections, but let a more direct
source override a stale summary. If artifacts conflict, describe the conflict,
identify the authoritative evidence, and do not guess.

The answer should make clear, when relevant:

- what was done and what remains;
- why a decision or phase exists;
- what changed in code and how data/control flows through it;
- what a review remark means and whether it was resolved;
- what must happen next and what evidence is missing.

When the question is broad (“explain the task”), produce a short overview,
timeline from the latest event chain, current design/state, unresolved items,
and a suggested next action. Add detail only behind cited links or headings.

## Safety and limits

Do not modify task notes, source, comments, or configuration unless the user
explicitly asks for a separate write operation. Do not claim that a search
provider found nothing without naming its root, query, and coverage. Do not
turn an event-log statement into proof when the cited source contradicts it.

If no index, latest event, or configured vault can be resolved, report the exact
recovery gap and ask for only the missing destination/profile or task identity.
If the task is complete, answer from its latest state and retain unresolved
remarks or historical context when they explain the result.

Return citations as vault-relative paths and headings/lines so another session
can reproduce the answer without loading the whole workspace.
