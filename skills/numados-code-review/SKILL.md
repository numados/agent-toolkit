---
name: numados-code-review
description: Perform high-signal reviews of pull requests, merge requests, commits, or local diffs, then validate every candidate issue with numados-verify-finding before reporting it. Use when the user explicitly requests a code review or when an approved implementation workflow reaches its final review gate for a supplied review URL or identifier, commit range, changed branch, local diff, or pasted patch. Resolve the source provider from the URL or repository instead of assuming a specific forge.
---

# Numados Code Review

Review changed behavior, not formatting. Return only verified, in-scope findings that merit the author's attention.

## Inputs and authority

Accept a pull/merge-request URL or identifier, a commit/range, a local diff, or pasted changes. Keep the operation read-only: do not edit code, post comments, approve, merge, or change remote state unless the user separately asks.

When given a URL, read [provider routing](references/provider-routing.md), identify the forge from the host and path, and select an already available provider that can read the target. Do not install, authenticate, or configure a provider. If the review source cannot be read, ask for the diff or one precise access detail rather than guessing.

## Review workflow

1. Establish the exact base/head scope and read repository instructions plus the requirement, issue, or PR description when available.
2. Map changed entry points, state mutations, public contracts, persistence, concurrency, security boundaries, and operationally important paths.
3. Trace changed behavior through relevant callers and consumers. Inspect dependent repositories only when the change affects a shared contract and those repositories are already in the approved scope.
4. Create a candidate only when evidence suggests a reachable defect with concrete impact. Ignore style, taste, speculative cleanup, and pre-existing problems the change does not activate or worsen.
5. Invoke `$numados-verify-finding` with every candidate, the review scope, and the evidence already collected. Treat candidates as hypotheses until verification completes.
6. Report only candidates classified as `Confirmed Blocker` or `Confirmed Issue`. Omit `False Alarm` and `Out of Scope`. Include `Needs More Evidence` only when the missing evidence is specific, the possible impact is material, and the user can reasonably obtain it.

If `$numados-verify-finding` is unavailable or cannot access required evidence, do not silently publish unverified candidates as findings. Report the verification gap and the smallest input needed to continue.

## Finding threshold

A reportable finding must satisfy all of these:

- The reviewed change introduces, activates, exposes, widens, or worsens it.
- A concrete input or runtime path reaches the problem.
- Existing guards, contracts, or tests do not refute it.
- The outcome affects correctness, security, data integrity, compatibility, reliability, or material performance.
- The finding has an exact changed line or the smallest changed causal anchor.

Treat a missing test as a finding only when a meaningful changed behavior is left unprotected, not merely because a line lacks direct coverage.

## Severity

- `Blocker`: credible security breach, data loss/corruption, or critical-path outage with no safe mitigation.
- `High`: expected usage breaks a contract, produces wrong results, or creates substantial reliability/performance risk.
- `Medium`: confirmed but bounded defect with limited blast radius or an accessible workaround.

Map verifier verdicts to severity: `Confirmed Blocker` is always `Blocker`;
classify a `Confirmed Issue` as `High` or `Medium` using the verified impact
and reach recorded in its evidence, not the candidate's original guess.

Do not report low-value nits.

## Output

Lead with findings, ordered by severity. For each finding use:

```text
[Severity] Short title — path/to/file.ext:line
Impact: Observable failure and affected scope.
Evidence: Minimal verified chain from changed code to failure.
Fix: Smallest safe direction or regression test.
Comment: The verifier's paste-ready sentences, kept verbatim.
```

Then add only:

- `Filtered:` counts of false alarms, out-of-scope candidates, and unresolved candidates, when non-zero.
- `Coverage:` important paths inspected and any material area that could not be verified.

If nothing survives verification, say `No actionable findings.` and state any material verification limitation. Do not add praise, generic summaries, or quick wins unless the user asks.

## Guardrails

- Read the actual implementation and contract before concluding.
- Distinguish fact, inference, and missing evidence.
- Verify serializer, framework, deployment, and configuration behavior from the active implementation or current authoritative docs.
- Scale retrieval and tests to the risk; do not launch parallel reviewers by default.
- Never expose secrets or sensitive exploit details unnecessarily.
