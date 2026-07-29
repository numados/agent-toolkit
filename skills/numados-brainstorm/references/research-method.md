# Research Method

Use the evidence, traceability, change-surface, and failure-analysis sections
for every task. Apply the full bounded-retrieval procedure when a task spans
several repositories, remote systems, or unfamiliar terminology.

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

## Match proof to the claim

Use evidence that can actually prove the statement:

| Claim | Minimum useful proof |
|---|---|
| Requirement or scope boundary | authoritative task artifact or explicit user/owner decision |
| Current code structure | direct source plus an all-occurrence search when claiming completeness |
| Framework, library, or provider behavior | configured version/provider plus authoritative current documentation |
| Deployed default or data semantic | target environment, schema, configuration, or owner contract |
| Runtime failure or recovery behavior | traced control/state flow and a representative test, log, or executable probe |
| Test feasibility | the actual test project, provider, fixture, and API/query capability |

Documentation can establish supported behavior, but it does not prove a
deployment default. Source can establish intended control flow, but it does not
prove an external system's contract. When representative execution is
impractical, keep the conclusion `Inferred` or `Open` and state what would prove
it.

## Requirements and scope traceability

Preserve the identity of each authoritative requirement:

```markdown
| Requirement source/id | Actor and trigger | Observable outcome | Constraint/scope | Evidence or gap |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |
```

Do not convert a bullet count into a named test count, silently split one
requirement into several official requirements, or label an engineering
safeguard as product acceptance. Derived scenarios are useful only when marked
as derived and traced back to their source requirement.

Treat public APIs, administrative endpoints, background workers, data
contracts, and new service-to-service surfaces as scope decisions. Include one
only when an authoritative requirement, explicit user decision, or verified
consumer needs it; the existence of nearby infrastructure is not evidence that
the task requires another surface.

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

## Change-surface census

When a task changes a symbol, contract, persisted field, or lifecycle:

1. locate its definition and all implementations, overrides, adapters,
   serializers, generated projections, fakes, mocks, and test fixtures;
2. trace callers and downstream consumers far enough to identify observable
   behavior and compatibility impact;
3. inspect dependency registration, process start order, lifetime boundaries,
   and disposal/cancellation ownership;
4. inspect persistence configuration, migrations, history/audit projections,
   indexes, uniqueness/null/case semantics, and concurrency controls;
5. inspect operational surfaces such as retry/reconciliation, health/readiness,
   metrics, and logging;
6. record which searches were exhaustive and which were only sampled.

Use exact or structural all-occurrence searches for known identifiers.
Semantic retrieval can discover candidates but cannot support a claim that all
implementers or consumers were found until verified against source.

## State and failure analysis

For any flow that changes durable state, publishes state, calls an external
system, or refreshes a cache, trace both success and failure:

```markdown
| Transition/failure point | Durable or visible state | Caller result | Recovery/retry | Health/log signal | Evidence |
|---|---|---|---|---|---|
| before write | ... | ... | ... | ... | ... |
| commit or external acceptance | ... | ... | ... | ... | ... |
| post-commit side effect | ... | ... | ... | ... | ... |
| cancellation/restart/concurrent operation | ... | ... | ... | ... | ... |
```

Pay special attention to failure after an irreversible step: the caller may
observe failure even though state changed. Establish convergence, idempotency,
retry ownership, stale-state behavior, and whether traffic must be blocked or
degraded until recovery. For reused sessions, contexts, or units of work,
establish whether a handled failure leaves state that can poison a later
operation.

Label an interleaving as hypothetical unless it was observed. A plausible
failure scenario can justify a risk or test, but it becomes `Confirmed` only
when the underlying states and transitions are evidenced.

## Baseline versus change impact

Classify adjacent defects or odd behavior as:

- pre-existing and unaffected;
- activated or worsened by the proposed change;
- introduced by the proposed change;
- unknown pending a named check.

Only the middle two are automatically part of corrective planning. Report a
pre-existing issue separately unless the user expands scope; do not hide it
inside the new feature or describe it as caused by the change.

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
