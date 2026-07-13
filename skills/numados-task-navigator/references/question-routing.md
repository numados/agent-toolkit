# Task Navigator Question Routing

## Initial read set

Always begin with the configured Obsidian task workspace, `_task_index.md`, and
the note named by `latest_iteration`. Treat this as the current-state index,
not as complete evidence. Follow links one hop at a time and stop when the
question is proven.

## Question classes

| Question | First detail source | Expand to |
|---|---|---|
| What was done/what remains? | latest iteration, index | plan, later/older events |
| Why was this chosen? | latest event, research decisions | evidence table, source/docs |
| What is the implementation plan? | plan | current source, tests, remarks |
| What changed in code? | event changed paths | diff, callers, tests, history |
| What does a review remark mean? | remarks + review event | changed code, contract, verifier evidence |
| What is blocked? | index blocker, latest handoff | open questions, failed checks, source |
| Explain the whole task | index + latest event | current projections, event chain, only relevant source |

For “around the task” questions, classify the requested radius before searching:

1. task state and decisions;
2. linked code path/contracts/tests;
3. relevant repository history;
4. linked remote objects or current documentation.

Do not expand to the next radius unless the current one cannot answer the
question or the user explicitly asks for it.

## Evidence discipline

For each answer claim, keep a source pointer:

- Obsidian: vault-relative path and heading/property;
- local code/config: repository-relative path and line or symbol;
- history: commit and changed path;
- remote/documentation: direct URL or provider object identifier.

The latest event is the best navigation shortcut, not automatically the most
authoritative source. A current source file or current contract can correct an
outdated event. Report contradictions instead of silently merging them.

## Efficient retrieval

- exact task IDs, phase IDs, remark IDs, and filenames: filename/lexical search;
- code symbols and callers: structural or semantic provider when available,
  then verify against source;
- conceptual note questions: optional semantic/hybrid search, then read the
  Markdown candidate;
- history questions: bounded Git history for the cited path or phase;
- remote questions: the reader that matches the supplied URL, without assuming
  a forge or CLI.

Keep candidate lists small, read snippets before full files, and include the
retrieval limit when evidence is incomplete.
