---
name: numados-pr-comment-report
description: Analyse pull-request review comments, verify each finding against the actual diff and repository behavior, classify True Alarm/False Alarm/Needs Evidence, and produce a concise copy-paste response report sorted by PR appearance order. Use when the user asks what to answer to PR comments, wants review-thread triage, or asks for responses to code-review discussions. Never post or modify PR comments.
---

# PR Comment Report

## Purpose

Turn PR review threads into a verified response sheet. The output is a report the user can copy into Azure DevOps (or another forge) manually. This skill is read-only with respect to the PR: never create, update, resolve, vote on, or otherwise post PR comments.

## Inputs

Required:
- PR URL or PR identifier and repository.

Use available PR tooling to retrieve the PR metadata and discussion threads. If thread retrieval is unavailable, ask the user to provide the thread export or pasted comments; do not guess discussion IDs or ordering. If only some threads are retrieved, produce a clearly labelled partial report.

## Verification procedure

1. Retrieve the PR description, source/target branches, changed files, and all discussion threads.
2. Sort review threads by the provider's explicit PR display/order field when available. Otherwise preserve the provider's returned order but label it `approximate provider order`; use `publishedDate` only as an explicitly approximate fallback. Never sort by numeric discussion ID unless the user explicitly asks. Preserve file/iteration context.
3. Ignore system/policy threads unless they contain an actionable review request.
4. For each actionable comment:
   - identify the exact claim and affected file/line;
   - inspect the PR diff and surrounding code;
   - trace guards, state transitions, persistence, concurrency, tests, and runtime assumptions;
   - check whether later commits already fixed it;
   - distinguish evidence from inference and unknown contract assumptions.
5. Classify each comment:
   - **True Alarm — Fixed**: real reachable defect and the current PR contains a verified fix;
   - **True Alarm — Open**: real defect still present; provide the smallest safe next action;
   - **False Alarm — Skip**: concern is prevented by existing code, contract, topology, or tests;
   - **Needs Evidence — Defer**: plausible but cannot be decided without an API contract, runtime data, or integration environment;
   - **Suggestion — Optional**: maintainability/configuration improvement, not a correctness defect and outside the requested scope;
   use the optional-response template below.
   - **Acknowledged — No Action**: positive/non-actionable feedback that does not require a code change.
6. For each classification, prepare a short response suitable for pasting into that thread. Never claim “fixed” without locating the fix and verifying tests/build. Never call a concern false without citing the guard or evidence.
7. Run a final consistency check: every retrieved review thread included by the report policy appears exactly once, order is preserved (or marked approximate), statuses match the evidence, and no response implies that the agent posted anything.

## Output contract

Return only a concise structured report, followed by a short verification summary:

```markdown
# PR comment response report

## 1. Discussion <id> — <short topic>
- Classification: **True Alarm — Fixed**
- Evidence: `<file/symbol/commit/test evidence>`
- Copy-paste response:
  > Fixed in `<commit>`: <one-sentence description>. Verified by <test/build>.

## 2. Discussion <id> — <short topic>
- Classification: **False Alarm — Skip**
- Evidence: `<guard/contract/topology/test>`
- Copy-paste response:
  > Skip — no change needed. <short reason>.

## 3. Discussion <id> — <short topic>
- Classification: **Needs Evidence — Defer**
- Missing evidence: `<specific contract/data/test needed>`
- Copy-paste response:
  > Defer for now — <specific unknown>. We need <evidence> before changing this.

## Verification
- Source checked: `<commit/diff>`
- Tests/build: `<results>`
- PR changes made by this skill: **None**
```

For **True Alarm — Open**, use:

```text
> Open — this is a valid issue because <short causal reason>. Proposed follow-up: <smallest fix>.
```

For **Acknowledged — No Action**, use:

```text
> Acknowledged, thank you. No change is required for this comment.
```

For **Suggestion — Optional**, use:

```text
> Optional follow-up — valid improvement, but not required for this PR's correctness/scope: <reason>.
```

## Response rules

- Keep each copy-paste response to 1–3 sentences.
- Say `Fixed` only for a real issue fixed in the current source branch.
- Say `Skip — no change needed` for false alarms; explain the decisive guard in one sentence.
- Say `Defer` when evidence is missing; name exactly what would resolve it.
- Do not hide unresolved high-severity findings in a general summary.
- If a thread is merely positive review feedback, classify it **Acknowledged — No Action** and use: `> Acknowledged, thank you. No change is required for this comment.` Omit it only when the user asks for actionable comments only.
- Report thread IDs exactly as retrieved, but order by PR appearance.

## Evaluations

### Trigger evaluations

- Positive: `Review PR 132524 and prepare copy-paste replies to all review comments, sorted by appearance. Verify which are true alarms and which are already fixed.` → activate this skill.
- Positive: `What should I answer to these Azure DevOps PR discussions?` with a PR URL → activate this skill.
- Near match: `Review this PR and find security vulnerabilities, but do not draft replies.` → route to a code-review skill unless the user also requests responses.
- Near match: `Post replies to all unresolved PR comments.` → do not activate as a posting workflow; explain that this skill is report-only. Activate only if the user also asks to prepare a report.

### Behavior evaluations

- Already-fixed finding: classify **True Alarm — Fixed**, cite the fixing commit/file/test, and provide a one-to-three-sentence `Fixed` reply.
- Guarded concern: classify **False Alarm — Skip**, cite the decisive guard or contract, and provide a `Skip — no change needed` reply.
- Unknown external contract: classify **Needs Evidence — Defer**, identify the exact missing evidence, and do not recommend an unverified code change.
- Unresolved real defect: classify **True Alarm — Open**, explain the causal path and smallest safe follow-up.
- Positive feedback: classify **Acknowledged — No Action** and use the exact acknowledgement template.
- Ordering: when no explicit display-order field exists, retain provider order and label the report ordering approximate; never substitute numeric discussion-ID sorting.
- Ordering: if API returns threads in appearance order `[568544, 568542, 568543]`, output exactly that order even though numeric sorting would differ.
- Safety: never call a PR create/update/comment/resolve/vote operation; the final verification must state `PR changes made by this skill: None`.
- Incomplete retrieval: include only retrieved threads, mark the report incomplete, and ask for the missing export/details; never invent missing discussion IDs or comments.

## Safe stop conditions

Stop and report the limitation if:
- the PR/repository cannot be identified; ask for that input before analysing;
- the changed commit cannot be inspected; return a partial report only for threads whose evidence is available;
- a finding depends on unavailable runtime/API evidence; classify that thread `Needs Evidence — Defer`;
- verification would require writing to the PR; never perform that write.

For incomplete thread retrieval, return the partial report, mark it incomplete, and ask for the missing thread export. Do not infer missing comments or silently reorder threads.
