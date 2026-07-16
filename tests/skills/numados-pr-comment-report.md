# numados-pr-comment-report evaluations

## Positive trigger

Provide a PR URL and several review threads, including one real issue fixed in a later commit, one guarded false alarm, and one comment dependent on an unknown external API contract.

Expected: retrieve/inspect the PR evidence, preserve provider appearance order, classify each thread separately, and produce concise copy-paste responses. The fixed issue must say `Fixed` and cite the commit; the guarded issue must say `Skip — no change needed`; the unknown contract must say `Defer` and identify the missing evidence.

## Ordering

Provide threads returned in appearance order with non-monotonic numeric IDs, for example `[568544, 568542, 568543]`.

Expected: retain the returned/provider order and do not sort numerically. If the provider exposes no explicit display ordering, label the ordering basis as approximate.

## Already-fixed finding

Provide a review comment and a later commit that fixes the exact code path, plus passing focused tests.

Expected: `True Alarm — Fixed`, with a one-to-three-sentence response containing the commit and verification evidence.

## False alarm

Provide a comment claiming a state can be overwritten, while a conditional update or concurrency guard prevents it.

Expected: `False Alarm — Skip`, with the guard cited and no speculative code change.

## Needs evidence

Provide a comment about undocumented pagination or an external response contract with no response sample or authoritative documentation.

Expected: `Needs Evidence — Defer`; name the exact contract evidence needed and do not claim it is fixed.

## Open issue

Provide a reachable defect that remains in the current source branch.

Expected: `True Alarm — Open`, with the causal path and smallest safe follow-up.

## Missing input/failure

Omit the PR identifier, or make thread retrieval incomplete.

Expected: ask for the missing PR identifier in the first case; in the second, return a clearly marked partial report and request the missing thread export. Never invent IDs or post replies.

## Acknowledged feedback

Provide a positive review comment with no requested change.

Expected: classify it `Acknowledged — No Action` and use the exact acknowledgement response template. It appears exactly once if the report includes non-actionable threads.

## Read-only boundary

Ask the skill to post, resolve, or vote on review comments.

Expected: refuse the write operation and provide a report-only response if enough read-only evidence is available.

## Harness discovery/removal

For every harness adapter that installs this skill, install it, verify the directory/name/description and any adapter metadata (including `agents/openai.yaml` for the OpenAI adapter) are discoverable, then remove or disable it.

Expected: each installed adapter exposes the skill by the directory/name and description; after removal it is no longer offered for routing. No PR or repository content is modified by discovery/removal validation.
