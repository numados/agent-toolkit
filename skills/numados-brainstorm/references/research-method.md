# Research Method

Use this reference when a task spans several repositories, remote systems, or
unfamiliar terminology.

## Small evidence set

Keep `research.md` decisive and short:

```markdown
| Claim | Class | Source | Consequence |
|---|---|---|---|
| ... | Confirmed / Inferred / Open | path:line, heading, artifact, or URL | ... |
```

Include a row only when it changes scope, design, verification, or a user
decision. `Confirmed` requires direct evidence. `Inferred` names the evidence
and reasoning. `Open` includes impact, confidence, and the next discriminating
check.

## Bounded retrieval

1. Locate the task index and latest iteration through the Obsidian skill.
2. Locate repository instructions, filenames, identifiers, entry points, and
   contracts.
3. Search exact terms and bounded variants.
4. Trace callers, consumers, reimplementations, configuration, persistence,
   and tests only as far as the decision requires.
5. Read the smallest source slices that prove the behavior.
6. Escalate to semantic, indexed, MCP, or remote retrieval only when lexical or
   structural evidence is weak or the source is outside the local root.
7. Verify every semantic or indexed candidate against the source document or
   code before using it as evidence.

Report the root, provider, exact query, candidate limit, and coverage
limitation. A no-match result means “not found with this route and scope,” not
“absent”.

## Current/target separation

Describe current behavior as an observed flow, including guards and side
effects. Describe target behavior as an intended contract and mark anything
that still needs user or system evidence. Never use desired behavior as proof
that the current system already works that way.

## Event handoff

At the end of a meaningful research pass, write one immutable event note under
`iterations/`. It links to the current index and `research.md`, records the
decision-relevant evidence and retrieval limits, and points to the next action.
The next session reads the index and this latest event first; it follows the
research note only when needed. Do not create one artifact per query or copy a
search transcript.

## Legacy Mag mapping

Read existing `context/research-summary.md`, `current-behavior.md`,
`target-behavior.md`, `open-questions.md`, and `repo-mapping.md` as one
research input. Keep their citations and classifications. Do not silently
convert an unresolved Mag question into a decision and do not create this
multi-file layout for a new task.
