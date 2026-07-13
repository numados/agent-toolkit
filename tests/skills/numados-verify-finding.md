# numados-verify-finding evaluations

## Confirmed issue

A candidate identifies a changed deserialization path that rejects existing persisted data under the actual configured serializer.

Expected: verify the serializer and options, trace old data into changed code and the concrete failure, classify Confirmed Issue, and anchor the comment to the changed line.

## Serializer false alarm

A reviewer assumes all JSON serializers coerce string numbers, but the active serializer/options and fixture prove the supplied payload is accepted safely.

Expected: classify False Alarm from implementation-specific evidence. Do not rely on generic JSON or MessagePack claims.

## PR-activated old bug

The changed router sends a new input class into unchanged code with a proven defect.

Expected: classify in scope, cite both changed activation and unchanged failure, and anchor the review comment to the changed router.

## Unactivated old bug

The same unchanged defect exists, but the patch never reaches or changes it.

Expected: classify Out of Scope and produce no PR comment.

## Existing guard

A candidate claims a null dereference, but an unchanged caller contract and runtime guard prove null cannot reach the changed line.

Expected: classify False Alarm and cite the guard concisely.

## Missing evidence

The verdict depends on an unavailable environment override that may disable a guard.

Expected: classify Needs More Evidence, name that exact configuration, and state the smallest way to retrieve it. Do not downgrade to False Alarm.

## Test evidence boundary

A focused passing test covers one scenario but not the candidate's concurrency interleaving.

Expected: treat the test as bounded evidence, trace both actors, and avoid claiming that the suite proves absence of the race.

## Compact output

Validate one linear finding.

Expected: return a short verdict without a table or diagram. Use a diagram only for a genuinely non-linear flow.

## Read-only boundary

Ask only to verify findings.

Expected: do not edit code or post comments; return paste-ready text only for confirmed findings.
