# Working tree currency

## Ownership

- Owner: numados toolkit
- Contract: `numados.working-tree-currency.v1`
- Scope: any agent work that reads, analyses, explains, reviews, plans, or
  changes code, configuration, or schema in a version-controlled checkout
- Status: normative

## Principle

Analysis inherits the age of the checkout it was performed on. A finding,
explanation, plan, or review derived from a stale branch is not merely
incomplete — it is confidently wrong about the current state of the system, and
it costs more than no answer because the reader cannot tell the difference.

Therefore: establish which revision is being analysed, and how current that
revision is relative to the remote, **before** producing conclusions about the
code. Report both alongside the result.

## Boundary with execution safety

[`execution-safety.md`](execution-safety.md) classifies `fetch`, `pull`,
`merge`, `rebase`, `reset`, and `checkout` as approval-required operations.
This contract never overrides that classification:

- Determining position and staleness uses **read-only** inspection only.
- Refreshing the local view of the remote requires an explicit user request or
  an already approved phase. Name the exact command and wait.
- Reconciling a diverged branch is never implied by this contract. Ask.

Staleness is therefore something an agent **proves or reports**, never
something it silently repairs.

## Required check before code analysis

Use read-only commands (`git rev-parse`, `git status`, `git log`, `git
rev-list`, `git for-each-ref`, `git show`) to establish:

1. **Identity of the analysed revision** — the short commit and the branch or
   detached state. A detached `HEAD`, a missing upstream, a submodule, or a
   worktree must be named explicitly rather than assumed to be the branch the
   user has in mind.
2. **Position relative to the tracked remote branch** — ahead/behind counts
   against the recorded upstream.
3. **Position relative to the integration branch** when the checkout is a
   feature branch, using the remote-tracking ref that already exists locally.
4. **Age of the local view of the remote** — when the remote-tracking refs were
   last updated. Remote-tracking refs are only as current as the last fetch;
   an ahead/behind count computed against a week-old ref proves nothing about
   the remote today.
5. **Uncommitted local state** — modified, staged, or untracked files that make
   the analysed content differ from any commit.

## Required outcome

Choose exactly one and state it:

- **Current** — the revision is provably up to date for the scope analysed.
  Proceed and record the analysed commit.
- **Stale or unproven** — the checkout is behind, diverged, or the local view of
  the remote is too old to decide. Report this **before** the findings, name the
  exact refresh command, and ask whether to refresh or to proceed against the
  current local state. If the user chooses to proceed, label the conclusions as
  bound to that revision.
- **Not applicable** — no version control, no remote, or the user explicitly
  scoped the work to the local state as-is. State which one.

Never present findings whose currency was neither established nor disclosed.

## Exceptions

- The user explicitly asks to work against the current local state, an
  arbitrary revision, a pasted diff, or an offline checkout.
- The remote is unreachable. Say so, and treat the result as unproven rather
  than current.
- The subject of the work is not repository content (a live incident, a running
  service, external documentation). Currency of the *evidence source* still
  applies; currency of the checkout does not.

An exception removes the refresh step. It never removes the requirement to
disclose which revision the conclusions rest on.

## Verification

Before delivering analysis, an explanation, a review, a plan, or a change:

1. Confirm the analysed revision is identified in the output.
2. Confirm the currency outcome above is stated, not implied.
3. Confirm no approval-required Git operation was executed without an explicit
   request.
4. When findings cite file paths or line numbers, confirm they were read at the
   analysed revision and not at an earlier one carried over from context.
