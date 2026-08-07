# Phase Design

## Evidence-to-plan traceability

Start with authoritative requirements and explicit user decisions, not a
derived task checklist:

```markdown
| Requirement source/id | Scenario and observable outcome | Phase | Acceptance | Verification |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |
```

Preserve source identities and wording closely enough to audit the mapping.
Mark extra failure, operability, security, and compatibility scenarios as
derived engineering safeguards. Do not claim that a requirement count proves
the existence of the same number of named tests.

Add a scope-authority ledger before the phase list:

```markdown
| Planned element | Authority | Source or prevented failure | Treatment |
|---|---|---|---|
| ... | Required / Approved / Derived safeguard / Proposal / None | requirement/decision reference or traced failure | phase / excluded / blocks plan |
```

`Confirmed` describes evidence strength, not permission to add work. Code can
prove that a legacy adapter exists; provider docs can prove an operation is
supported; a review can expose a risk. None selects that adapter, operation, or
risk response for the feature. Only Required/Approved scope or a truly minimal
Derived safeguard enters an executable phase.

A Derived safeguard cannot introduce a new technology, external/admin/manual
surface, persisted domain concept, worker, user-visible restriction, rollout stage,
or recurring operational responsibility. Those are Proposals until approved,
even when they would make the design safer or more complete.

## File map first

List every create/modify/test/configuration file in `plan.md` before task
details. Give each file one responsibility. Follow the repository's actual
organization; do not impose a new layering scheme because it looks cleaner in
isolation.

For a new component, compare nearby examples for naming, visibility,
constructors, dependency direction, error handling, serialization,
registration, test style, and documentation. Record the evidence and reason
for choosing a pattern. If examples diverge, keep the question open until the
repository or authoritative documentation resolves it.

Before calling the map complete, use all-occurrence searches for every changed
interface, base type, schema field, configuration key, message, or public
contract. Include:

- all implementations, overrides, adapters, generated projections, fakes,
  mocks, fixtures, callers, and downstream consumers;
- dependency registration, hosted/process start order, lifetime boundaries,
  cancellation ownership, and disposal;
- persistence mappings, migrations, history/audit storage, indexes,
  constraints, null/case/comparison semantics, and concurrency behavior;
- retry/reconciliation, health/readiness, logging, metrics, and operational
  controls.

Record coverage limits. A sample of nearby files supports a pattern choice but
does not prove that every affected implementation was found.

## State and failure design

For each durable write, external acceptance, publication, cache refresh, or
other irreversible/visible transition, state:

```markdown
| Point | Success state | Failure/cancellation state | Recovery owner | Traffic/health behavior | Verification |
|---|---|---|---|---|---|
| before effect | ... | ... | ... | ... | ... |
| effect committed | ... | ... | ... | ... | ... |
| post-effect work | ... | ... | ... | ... | ... |
| concurrent/restart path | ... | ... | ... | ... | ... |
```

A plan is incomplete if committed state can diverge from in-memory, published,
or downstream state without a convergence path or an explicit correctness
gate. Define retry/idempotency, ordering/serialization scope, stale-state
policy, cancellation ownership, and operator visibility as applicable.

For reused contexts, sessions, connections, or units of work, define how a
handled failure resets invalid local state. Include a test where a later valid
operation succeeds in the same lifetime when that lifetime is material.

## Provider-realistic verification

Match every check to the behavior it can prove:

- use fast isolated tests for pure business rules and deterministic
  transformations;
- use the configured provider/version for provider-specific queries,
  migrations, transaction behavior, constraints, collations/comparers,
  generated values, and real exception metadata;
- inspect generated migrations or schema operations, then verify the resulting
  current/history/audit/index shape against a representative instance when
  those details affect correctness;
- verify startup/registration ordering through the real composition path when
  order or lifetime matters;
- when translating a constraint or provider error, distinguish the intended
  constraint from other failures with the same broad error category.

Do not assign a check to an in-memory fake or mock that cannot execute the API
or semantics being claimed. Do not prescribe provider-specific fallback DDL,
cleanup, or recovery unless that action is itself verified.

## Right-size phases

A phase is the smallest coherent change that deserves its own verification and
commit boundary. Keep tightly coupled setup, implementation, tests, and required
documentation together. Split when a reviewer could accept one change while
rejecting the next, or when the result can be built and tested independently.

Prefer a small number of meaningful phases over a long checklist of trivial
edits. Use stable IDs such as `P1`, `P2`, and `P3`; never renumber a completed
phase when extending a plan.

## Phase extension

An extension is justified only by verified new evidence: a missing contract,
unreachable acceptance condition, discovered integration boundary, failed
verification, or a confirmed review finding that needs a separate increment.
The extension must state:

- the evidence and why existing phases cannot cover it;
- the new stable phase ID and dependency;
- exact files/symbols/contracts;
- observable acceptance and verification;
- risk, recovery, and resulting-change boundary;
- whether it changes approved scope and therefore needs user approval.

If it only decomposes behavior already approved, record that rationale and keep
the original approval. Otherwise stop at the planning gate.

## Acceptance and verification

Each phase states observable acceptance, not only changed files. Include the
focused check and expected signal, regression coverage, formatter/linter/
compiler/schema/migration checks, and a manual or operational check when
automation cannot prove the contract. Use exact commands discovered during
research. If a command cannot safely run, record the limitation and the
alternative evidence required.

## Commit boundary

A phase commit contains only that phase's resulting behavior, tests,
configuration, or documentation. A plan may state that a commit is expected
and what it contains, but must not prescribe a universal commit syntax or copy
ticket/provider metadata into the message. Use `$numados-commit-message` later
when text is needed.

## Plan self-check

Before handoff, ask:

1. Does every authoritative requirement map to a scenario, phase, acceptance
   signal, and capable verification seam?
2. Are derived safeguards clearly distinguished from product acceptance?
3. Can an implementer find every touched file, implementation, test double,
   registration, and consumer without rediscovering the scope?
4. Does each phase leave a buildable and testable state?
5. Does every target-behavior statement have a task and acceptance check?
6. Are failure after durable/external effects, cancellation, concurrency,
   restart, recovery, health, and logging handled where relevant?
7. Can a handled failure poison a later operation in the same lifetime?
8. Are comparison, uniqueness, null, collation, and persistence semantics
   aligned across memory and storage?
9. Can each chosen test provider execute the behavior it claims to verify?
10. Are current patterns, version constraints, deployed defaults, and external
    APIs proven by suitable evidence?
11. Are pre-existing unaffected defects and unapproved new surfaces outside the
    plan?
12. Are unresolved questions visible, with material ones blocking approval?
13. Is the final review scope explicit?
14. Is every supplied decision-relevant source read or explicitly blocking?
15. Does every obligation, component, restriction, fallback, repository and
    phase have Required/Approved authority or a traced minimal safeguard?
16. Did any code capability, provider document, review recommendation,
    historical note, or model proposal silently become required scope?
