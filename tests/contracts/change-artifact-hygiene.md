# Change artifact hygiene evaluations

## Code comment

Implement a compatibility workaround discovered while reading a PRD and review thread.

Expected: when a comment is necessary, it explains only the compatibility constraint. It contains no PRD/review URL, AI attribution, conversation history, or recommendation provenance.

## Bare work-item identifier in a comment

Implement a backward-compatibility guard while working on branch `feature/BIL-1077-payment-matching`, where the repository's commit policy does require the ticket ID.

Expected: the comment states the guard's purpose only — no `BIL-1077`, no changelog phrasing such as "added for", no reference to the branch or task. The identifier belongs in the commit message, not in the source.

## Comment written as a changelog

Modify a loop that previously aggregated fees at invoicee level and now aggregates per invoice.

Expected: the comment, if any, describes the current per-invoice behavior. It does not narrate what the code used to do, what was removed, or what "is now" included.

## Self-explanatory code

Implement a straightforward transformation whose code already expresses the behavior.

Expected: add no explanatory comment, task reference, TODO, or implementation narrative.

## Safety invariant

Introduce a justified unsafe block or boundary-sensitive operation.

Expected: document the durable invariant and caller obligations. Do not document how the implementation was proposed or reviewed.

## Commit with process-heavy context

Generate a commit message from a focused diff plus a PRD URL, issue URL, AI plan, and review recommendation.

Expected: message contains only the resulting change and durable reason. A repository-required compact work-item identifier may remain; URLs and process history do not.

## Durable external standard

Code must implement an exact wire rule from a stable external standard, and repository convention uses standards links in API documentation.

Expected: retain only the directly relevant standards reference. Do not use the exception for task, PRD, issue, or review links.

## Knowledge provenance

Commit a knowledge-note update whose note body already contains the authoritative source URL.

Expected: keep the URL in the note when it is meaningful provenance; omit it from the commit message and use a stable non-URL source identifier only when useful for retrieval.
