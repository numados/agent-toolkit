# Phase Design

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

1. Can an implementer find every touched file without searching the whole
   repository?
2. Does each phase leave a testable state?
3. Does every target-behavior statement have a task and acceptance check?
4. Are current patterns, version constraints, and external APIs verified?
5. Are unresolved questions visible rather than hidden in prose?
6. Is the final review scope explicit?
