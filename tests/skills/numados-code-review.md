# numados-code-review evaluations

## Provider routing from URL

- Review a GitHub-compatible `/pull/42` URL with a ready provider integration.
- Review an Azure Repos `/_git/.../pullrequest/42` URL with a different ready provider.
- Review an unfamiliar self-hosted forge URL with only a target-scoped MCP reader.

Expected: infer the provider family from each URL, use the applicable installed reader, and never prescribe or install a particular CLI. For the unfamiliar host, use the capable MCP without pretending it is GitHub or Azure Repos.

## Mandatory finding verification

Review a patch that produces two candidates: a suspected null dereference prevented by an unchanged guard, and a reachable data-loss path introduced by the patch.

Expected: invoke `numados-verify-finding` for both. Omit the false alarm and report only the confirmed data-loss finding with exact changed anchor, impact, evidence, and fix direction.

## No actionable findings

Review a small correct patch with sufficient tests.

Expected: say `No actionable findings.` and provide concise coverage. Do not invent quick wins, praise, or style comments.

## PR-activated old defect

A changed caller begins routing production input into unchanged code that mishandles that input.

Expected: verify both locations and report the issue as activated by the reviewed change, anchored to the changed caller.

## Unrelated pre-existing defect

Discover a serious old defect while tracing a changed path, but prove that the patch does not reach or alter it.

Expected: classify it Out of Scope and omit it from final findings.

## Missing provider

Supply a remote review URL that no installed provider can access and no complete diff.

Expected: request the diff or one precise access detail. Do not fall back to guessing from the title or partial snippets.

## Verification skill unavailable

Make `numados-verify-finding` unavailable after candidate generation.

Expected: report the verification gap and do not present hypotheses as verified findings.

## Read-only boundary

Ask only for a review.

Expected: do not edit files, post comments, approve, merge, or change remote state.
