---
name: numados-tdd
description: Plan tests at business-rule seams and implement through TDD. Use during numados-planning to add test coverage to phases, during numados-implementation to enforce red-green-refactor per phase, or when the user explicitly asks to add tests to untested legacy code. Route test findings that need review to numados-code-review.
---

# Numados TDD

Tests are executable business-rule documentation, not coverage artefacts.
Every test describes **what** the system must do at a named public seam.
Implementation details, private methods, trivial getters, and framework code
are not test targets — their behaviour is verified through the seams that
depend on them.

When invoked, resolve the operating mode from context:

- **Planning mode** — called during or alongside `$numados-planning`. Read the
  current `plan.md`, identify test seams per phase, and extend each phase with a
  test list and verification commands. Do not modify product source.
- **Implementation mode** — called during or alongside
  `$numados-implementation`. For each planned phase, enforce the TDD cycle:
  failing test first, minimal code, verify green, then refactor. Record test
  results in the phase iteration event.
- **Legacy mode** — the user explicitly asks to add tests for existing untested
  code. Analyse business rules, identify seams, produce a test list for
  approval, then implement each test through the TDD cycle.

## Boundary and recovery

This skill may read the repository and extend `plan.md` with test sections. In
implementation and legacy modes it may create and modify test files. It must
not push, deploy, merge, or change product behaviour beyond what the plan or
user request authorises.

Durable workflow notes are Obsidian-backed. Resolve the task workspace through
`$numados-obsidian-knowledge` before reading or writing `plan.md` or iteration
events. Follow the same recovery order as `$numados-planning` and
`$numados-implementation`:

1. `_task_index.md`;
2. `latest_iteration` event;
3. current `plan.md`;
4. `research.md` only when a business rule is ambiguous.

## Core discipline

Every rule below is mandatory. The skill's value is not the tests themselves —
it is the **behavioural contract** they lock in before implementation begins.

### 1. Seams first

A **seam** is a public boundary where behaviour can be observed without reaching
inside the system. Tests live at seams, never against internals.

Before writing any test, [identify the seams](references/seams.md) and confirm
them. The user decides which seams matter. One unconfirmed seam, one wasted
test.

### 2. Test list before code

From Kent Beck's Canon TDD: list the scenarios you want to cover, then turn
exactly one item into a concrete test. The list is a filter — if a scenario
does not describe observable business behaviour, it does not belong on the
list.

Follow [test-list.md](references/test-list.md) for creating, maintaining, and
extending the list.

### 3. Red before green

Every line of production code must be preceded by a failing test that demands
it. Write the test, watch it fail for the expected reason (feature missing, not
a typo), then write the minimal code to make it pass.

Follow [tdd-cycle.md](references/tdd-cycle.md) for the exact RED-GREEN-REFACTOR
sequence and verification gates.

### 4. Behaviour, not implementation

A test must survive internal refactoring. If renaming a private method or
restructuring internal logic breaks the test, the test was coupled to
implementation.

See [anti-patterns.md](references/anti-patterns.md) for what must never appear
in a TDD test.

## Planning mode

When the active task is in planning status and `plan.md` exists:

1. Read the current plan — goal, phases, file map, acceptance criteria.
2. For each phase, identify the public seams that the phase touches or creates.
   A seam is an API endpoint, a service method, a command handler, a repository
   interface, a module's public function — anything a caller interacts with.
3. For each seam, list the business-rule scenarios that must be verified.
   Scenarios come from the research (`research.md`), the plan's target-behaviour
   statements, and explicit user confirmation.
4. Extend each phase in `plan.md` with:

```markdown
### P<N> test coverage

Seams under test:
- `<seam path or interface name>` — `<why this seam matters>`

Test list:
- [ ] `<scenario>` — `<expected outcome>`
- [ ] `<scenario>` — `<expected outcome>`

Verification:
- `<exact test-run command>`
- Expected: `<N tests, all passing>`
```

5. Keep the test list to business-rule scenarios. Exclude:
   - "test that the controller exists"
   - "test that the dependency is injected"
   - "test that the method returns the right type"
   - Any scenario that does not distinguish correct from incorrect behaviour.

6. Record the test planning in the planning iteration event with a
   `test-coverage` section listing seams, scenario count, and any explicitly
   excluded areas with rationale.

7. Return:

```text
Status: TEST PLAN EXTENDED
Seams identified: <count>
Scenarios listed: <count>
Excluded (with reason): <list or none>
Next: <approval or implementation>
```

If the plan or research is too thin to identify meaningful seams, stop and
report what is missing. Do not invent business rules to fill a gap.

## Implementation mode

When the active task is in implementing status and `plan.md` includes test
coverage sections:

For each phase, before writing product code:

1. Pick the first unchecked scenario from the phase's test list.
2. Write the test. Follow [tdd-cycle.md](references/tdd-cycle.md) — RED
   (failing for the right reason) → verify RED → GREEN (minimal code) → verify
   GREEN.
3. Mark the scenario `[x]` in the plan only after GREEN is verified.
4. Repeat for the next scenario.
5. After all scenarios pass, run the refactor check:
   - Remove duplication
   - Improve names
   - Keep tests green throughout
6. Add product behaviour only through this cycle. If a needed behaviour has no
   scenario, stop and add one to the test list before proceeding.
7. Record test results in the phase iteration event:

```markdown
## Test results
- Seam: `<name>`
- Scenarios: <passed>/<total>
- Test file(s): <paths>
- Verification: `<command>` — <result>
```

If a scenario cannot be tested at the identified seam, record the limitation
with its reason and consider whether the seam was misidentified or the test
needs a different boundary.

**Red flags — stop and do not proceed:**

- Code written before the test.
- Test passes immediately (testing existing behaviour, not the new scenario).
- Test fails with an error, not an assertion failure.
- "I'll add the test after" — this is not TDD.
- Scenario not on the approved test list.

## Legacy mode

When the user explicitly asks to add tests for existing untested code:

1. Identify the code scope — repository, module, class, or path.
2. Read the code and extract observable business rules. A business rule is a
   statement of the form "given X input / state, the system produces Y output /
   state change through Z seam."
3. Identify the public seams. Ignore private helpers, internal wiring, and
   framework boilerplate.
4. Produce a test list organised by seam. Present it to the user:

```text
## Proposed test list for `<scope>`

### Seam: `<public-interface-path>`
- [ ] `<business scenario>` — `<expected observable outcome>`
- [ ] `<business scenario>` — `<expected observable outcome>`

Excluded:
- `<area>` — `<reason (no business logic, framework code, etc.)>`

Total scenarios: <count>
```

5. Wait for user approval. Do not write a single test until the list is
   confirmed.
6. After approval, implement each scenario through the TDD cycle. Since the
   code already exists, the "RED" phase verifies that the test fails when the
   behaviour is temporarily broken (or that the test correctly describes
   behaviour not yet covered). If the test passes immediately and you cannot
   make it fail, the scenario may already be tested — flag it and move on.
7. Record results: tests created, scenarios covered, paths changed.

## Interaction with other numados skills

- **$numados-planning**: this skill extends the plan with test coverage.
  Planning remains the authority for phase structure and acceptance.
- **$numados-implementation**: this skill enforces the TDD cycle inside each
  phase. Implementation remains the authority for source changes and commits.
- **$numados-code-review**: after implementation, review validates that tests
  are behaviour-focused. Do not duplicate the review here.
- **$numados-verify-finding**: a review finding about a missing or
  implementation-coupled test is a valid finding. Address it through this
  skill's TDD cycle, not by adding a test after the fact.

## When not to use

- Trivial configuration changes with no behavioural surface.
- Generated code with upstream tests.
- Throwaway prototypes (user explicitly says so).
- The user is asking for a code review, not test authoring — route to
  `$numados-code-review`.
- The research or plan is not ready — route to `$numados-brainstorm` or
  `$numados-planning` first.

## Quick reference

| Rule | Why |
|------|-----|
| Seams confirmed before tests | effort goes to critical paths |
| Test list before code | filters out non-behaviour |
| RED verified before GREEN | test proves the gap exists |
| Minimal code per test | no YAGNI, no speculation |
| Behaviour through public API | tests survive refactoring |
| Expected values from spec, not code | no tautologies |
| One scenario per test | pinpoint failures |
| Private methods untested directly | implementation detail |
