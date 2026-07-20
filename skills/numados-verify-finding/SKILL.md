---
name: numados-verify-finding
description: Validate suspected code-review findings or existing PR comments against the actual change, contract, data flow, guards, tests, and runtime assumptions. Classify each as True (Confirmed Blocker / Confirmed Issue), False alarm, Out of Scope, or Needs More Evidence. Use when numados-code-review supplies candidate findings, when the user asks whether review feedback is valid before posting or acting on it, or when existing PR discussion threads must be verified.
---

# Numados Verify Finding

Treat every candidate as an untrusted hypothesis. Return a verdict only after tracing the relevant behavior far enough to prove, refute, or precisely bound the claim.

## Inputs and authority

Require the candidate claim plus its review scope: URL/diff/commit, file and line when known, and expected impact. Reuse evidence supplied by `$numados-code-review`, but verify it independently.

Keep the operation read-only. Do not edit code or post a review comment. If the change, contract, or required source cannot be accessed, ask for the smallest missing artifact or return `Needs More Evidence` with that exact boundary.

## Verification method

For each candidate:

1. **State the contract.** Identify the requirement, invariant, public contract, established behavior, or security property the claim depends on. Do not substitute a reviewer preference for a contract.
2. **Establish scope.** Determine whether the reviewed change introduces the problem or newly activates, exposes, widens, or worsens pre-existing behavior.
3. **Trace the path.** Follow the actual trigger, input guarantees, changed code, guards, state transitions, and downstream consequence. Read unchanged callers, implementations, configuration, schemas, and consumers when they decide the result.
4. **Challenge assumptions.** Verify the actual serializer, framework options, feature flags, deployment topology, data shape, concurrency model, and version involved. Use source or current authoritative documentation rather than generic ecosystem behavior.
5. **Seek discriminating evidence.** Use existing tests, a focused read-only check, or a minimal reproduction when proportionate and safe. A passing test supports only the scenario it covers; it does not prove the absence of every failure.
6. **Check the causal anchor.** Identify the smallest changed line that creates or admits the bad state. For a PR-activated old bug, identify both the changed activation point and the unchanged defective behavior.

Stop once the verdict is established. Do not exhaustively investigate unrelated risks.

## Verdicts

| Verdict | Required evidence |
|---|---|
| `Confirmed Blocker` | Reachable, in-scope severe security, data-integrity, or critical-availability failure with no adequate guard or mitigation |
| `Confirmed Issue` | Reachable, in-scope correctness, compatibility, reliability, or material-performance defect with concrete impact |
| `Needs More Evidence` | Material claim remains plausible, but one named contract, configuration, source, or runtime fact prevents a sound verdict |
| `False Alarm` | The claimed failure is impossible under the verified contract or an existing guard prevents it |
| `Out of Scope` | A real or possible pre-existing problem that the reviewed change does not touch, activate, expose, widen, or worsen |

Never turn missing evidence into `False Alarm`. Never turn an unactivated pre-existing bug into a PR finding.

## True / False alarm classification

Map every verified verdict to its alarm status for the summary table:

| Verdict | True / False alarm | Meaning |
|---|---|---|
| `Confirmed Blocker` | **True** | Real defect; must be fixed. |
| `Confirmed Issue` | **True** | Real defect; should be fixed. |
| `False Alarm` | **False** | Claim is impossible under the verified contract or an existing guard prevents it. |
| `Out of Scope` | *(not a finding)* | Pre-existing problem the reviewed change did not touch, activate, or worsen. |
| `Needs More Evidence` | *(unresolved)* | One named fact prevents a sound verdict; do not present as True or False. |

Only `Confirmed Blocker` and `Confirmed Issue` carry a **True** alarm status and should be posted or acted on.

## Actionability gate

A candidate survives as a review finding only when all are true:

- verdict is `Confirmed Blocker` or `Confirmed Issue`;
- origin is in scope;
- impact is observable and worth the author's attention;
- evidence identifies a reachable failure path;
- an exact changed causal anchor and a practical fix or test direction exist.

Code style, preference, speculative cleanup, and generic “add tests” advice do not pass this gate.

## Output

### Mode A — Verify existing PR discussion threads

Use when the input includes Azure DevOps (or other forge) discussion thread IDs from an existing pull request. Include Discussion ID and Comment ID columns.

Open with a compact verification table sorted by Discussion ID:

```text
| Discussion ID | Comment ID | Classification | True / False alarm | Short finding | Action |
|---:|---:|---|---|---|---|
| 570277 | 1 | Confirmed Issue | True | Retry may lose standalone premium reversal | Post/fix |
| 570278 | 1 | False Alarm | False | TBD finance/PO comment is required by ticket AC | Do not post |
| 570279 | 1 | Out of Scope | — | Redundant UpdateData calls predate the PR | Do not post |
```

Column rules:
- **Discussion ID** and **Comment ID** — optional; include only when the forge provides them. Omit the column when no candidate carries an ID.
- **Classification** — one of `Confirmed Blocker`, `Confirmed Issue`, `False Alarm`, `Out of Scope`, `Needs More Evidence`.
- **True / False alarm** — `True` for confirmed defects, `False` for false alarms, `—` for out-of-scope / needs-more-evidence.
- **Short finding** — one-line summary of the claim.
- **Action** — `Post/fix` for True findings, `Do not post` for False/Out of Scope, `Gather evidence` for Needs More Evidence.

After the table, detail every confirmed finding:

```text
[Confirmed Issue] Short title — path/to/file.ext:line
Contract: Expected behavior or invariant.
Evidence: Trigger → changed behavior → missing/insufficient guard → consequence.
Impact: Observable failure and affected scope.
Fix: Smallest safe direction or regression test.

Short PR comment:
> Two or three paste-ready sentences for the Azure DevOps thread.
```

### Mode B — Verify regular candidate findings

Use when reviewing raw candidates from `$numados-code-review` or a manual investigation that does not target existing PR threads. Discussion/Comment IDs are optional.

Open with a compact verification table:

```text
| # | Classification | True / False alarm | Short finding | Anchor |
|---:|---|---|---|---|
| 1 | Confirmed Blocker | True | Empty retry set completes EOD after a failed recreation | RetryEodBookingsHandler.cs:156 |
| 2 | False Alarm | False | CH gate suppresses street-hedge | ExecuteEodBookingsHandler.cs:326 |
| 3 | Out of Scope | — | Old metadata lookup defect | RetryEodBookingsHandler.cs:146 |
```

For every confirmed finding, return:

```text
[Verdict] Short title — path/to/file.ext:line
Contract: Expected behavior or invariant.
Evidence: Trigger → changed behavior → missing/insufficient guard → consequence.
Impact: Observable failure and affected scope.
Fix: Smallest safe direction or regression test.

Short PR comment:
> Two or three paste-ready sentences anchored to the changed line.
```

### Common — Filtered and Coverage

After all findings, append a Filtered and Coverage summary:

```text
## Filtered
- False alarms: 3
- Out of scope: 1
- Needs more evidence: 1 (missing fact: <what>; obtain via <how>)

## Coverage
- Files inspected, test results, iterations reviewed, and any material limitation.
```

For `Needs More Evidence`, name only the missing fact and the smallest way to obtain it. For `False Alarm` and `Out of Scope`, give one concise reason in the table; no PR comment.

Use a diagram only when concurrency, branching, or three or more interacting components are materially clearer visually. Do not force tables or diagrams for a single linear finding.

## Handoff to code review

Return verdicts in a form `$numados-code-review` can filter directly. It should publish only confirmed, actionable findings and may summarize rejected candidate counts without repeating them. When verifying existing PR threads, the table maps every thread to a True/False decision the caller can use to accept, resolve, or dismiss each comment.
