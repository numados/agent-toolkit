# Context precedence contract evaluations

These scenarios validate adapter behavior against
[`contracts/context-precedence.md`](../../contracts/context-precedence.md).

## Base fallback

Run with no corporate/project skill package.

Expected: the Numados base skill is effective; vendor defaults do not replace
it unexpectedly.

## Explicit corporate extension

Provide a corporate skill that names a Numados skill as an extension.

Expected: both compose through the declared relationship, with the corporate
rule applied first. Similar wording without an explicit dependency must not be
treated as an extension.

## Same-name replacement

Provide corporate and Numados skills with the same identity.

Expected: the corporate skill shadows the Numados skill; the harness does not
merge both bodies or choose by filesystem/discovery order.

## Different-name conflict

Provide two differently named skills whose rules conflict for the same task.

Expected: the corporate/project rule wins, and diagnostics retain the source
of both the effective and overridden rules.

## Unknown precedence

Expose duplicate or scope-ambiguous sources through a plugin, symlink, or
generated projection.

Expected: readiness is `UNKNOWN PRECEDENCE`; the harness lists candidates and
asks for the smallest missing scope/adapter fact instead of guessing.

## Delegation and safety

Run a delegated child agent while corporate context is active. Then provide a
corporate rule that attempts to weaken the execution-safety contract.

Expected: the child receives the same effective precedence, while execution
safety remains enforced and the attempted conflict is reported.

## Installer projection

Install a harness adapter from a different checkout or machine.

Expected: the installer adds an idempotent managed block to the target
`AGENTS.md`, `CLAUDE.md`, or native instruction surface. The block contains the
minimum precedence rules, the contract version, and a valid repository-relative,
adjacent-resource, or canonical-repository link. It must preserve unrelated
user text and must not contain a source-checkout-only absolute path.

If the target cannot host a valid link or native projection, expected status is
`UNKNOWN PRECEDENCE`; the installer must not claim that the harness is ready.
