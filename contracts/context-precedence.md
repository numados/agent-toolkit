# Context precedence

**Owner:** numados toolkit
**Contract:** `numados.context-precedence.v1`
**Scope:** skills, agent instructions, workflow rules, and behavior-changing
harness context loaded together for one task
**Status:** normative

## Purpose

Company- or project-provided skills may deliberately specialize or replace a
portable Numados skill. Every harness must resolve that relationship
deterministically instead of relying on discovery order, directory names,
symlink order, or whichever instruction was loaded last.

This contract governs conflicts within agent context. It does not weaken the
harness's system/developer safety boundary, the user's explicit task scope, or
the non-negotiable rules in [`execution-safety.md`](execution-safety.md).

## Precedence

For the same subject or behavior, apply the most specific applicable source in
this order:

1. **Project/company context** — rules and skills supplied for the target
   project or organization, including a project-local corporate package.
2. **Numados base context** — reusable `numados-*` skills, contracts, and
   shared baseline memory.
3. **Harness/vendor defaults** — built-in behavior and generic installed
   context that is not classified above.

If the company provides both organization-wide and project-local context, the
project-local source is more specific. A source must declare or be assigned a
scope and provenance; an unclassified source must never silently outrank
project/company context.

## Conflict resolution

- Same identity/name: activate the highest-precedence implementation and
  shadow lower-precedence duplicates. Do not merge two bodies implicitly.
- Different identities with overlapping rules: keep both only when they are
  compatible. For a conflict, the higher-precedence project/company rule wins;
  report the lower rule as overridden and preserve both source references.
- A company skill may explicitly depend on or extend a Numados skill. That
  relationship must be named; it must not be inferred from similar wording.
- A base skill must not override, weaken, or silently reinterpret a
  project/company rule. If the conflict affects safety, permissions, secrets,
  remote writes, or approval gates, stop and report it rather than resolving it
  by precedence alone.
- If scope or precedence cannot be determined, do not claim the effective
  configuration is ready. Report `UNKNOWN PRECEDENCE`, list the candidates,
  and ask for the smallest missing adapter or scope fact.

## Harness adapter requirements

Each harness adapter must:

1. discover all applicable context sources for the target;
2. classify each source as project/company, Numados base, or vendor/default;
3. apply the order above before activation or prompt composition;
4. expose the effective source and any shadowed/overridden conflict in a
   diagnostic mode;
5. pass the effective corporate/project rule to delegated agents; and
6. preserve the same behavior when a source is installed through a symlink,
   plugin, marketplace, or generated projection.

The adapter may use harness-native names and files, but those are projections,
not new policy sources. It must not encode a different priority order for one
harness without recording a compatibility exception and its verification.

## Installation and projection

The harness-specific adapter installer owns propagation into the target
harness. A generic skill installer may call that adapter, but must not guess
native configuration fields or treat skill discovery as instruction
projection.

For every supported target, the installer must:

1. add a concise managed projection to the harness's instruction surface
   (`AGENTS.md`, `CLAUDE.md`, native instructions, or the equivalent);
2. include a stable link to this full contract and identify its contract
   version;
3. keep the minimum precedence rules in the projection because a harness may
   not follow links automatically;
4. use a valid repository-relative link, deployed adjacent resource, or
   canonical repository URL. Never emit a source-checkout-only absolute path;
5. update only its marked block, preserve unrelated user content, and remain
   idempotent; and
6. fail or report `UNKNOWN PRECEDENCE` when the link/resource cannot be made
   valid for the target installation.

The projection is not a second policy source. Its marked block is generated
from this contract, while the full contract remains the source of truth.

## Minimum verification

Test every adapter with:

- no corporate context: Numados base remains effective;
- a corporate rule that extends a base skill: both compose explicitly;
- same-name corporate and base skills: corporate shadows base;
- different-name conflicting rules: corporate rule wins and provenance is
  visible;
- ambiguous scope or duplicate sources: readiness is unknown, not guessed;
- delegated child agent: the same effective corporate precedence is preserved;
- corporate context attempting to weaken execution safety: the safety contract
  remains enforced and the conflict is reported.
