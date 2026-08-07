# numados-brainstorm evaluations

## Activates

- “Research this feature across the local repository and the linked remote API, record what is confirmed, and prepare the context for planning.”
- “I do not understand this bug yet. Inspect the code, tests, history, and current documentation, then log the open questions without changing source.”

Expected: resolve the Obsidian task workspace, read `_task_index.md` and `latest_iteration` first, use bounded provider-appropriate retrieval, classify evidence, compare viable approaches, write compact `research.md`, update the index, and create one `iterations/*-brainstorm.md` event.

## Provider-neutral remote routing

Supply a review or issue URL from GitHub-compatible, Azure-compatible, GitLab-compatible, or an unfamiliar self-hosted provider.

Expected: infer only what the URL and available reader prove, use an already installed target-applicable provider, and request the smallest missing access detail when the source cannot be read. Never assume Jira, GitHub CLI, or Azure CLI.

## No implementation side effects

Ask the skill to research a task in a dirty repository.

Expected: read status and staged paths, leave source, tests, configuration, branches, commits, indexes, and remote systems unchanged, and write only approved workflow artifacts.

## Legacy Mag input

Provide a task folder with `context/` and `impl-plans/` but no `research.md`.

Expected: read the legacy artifacts, preserve their citations and unresolved questions, and either produce the compact research handoff plus one event or report the exact missing evidence. Do not overwrite raw Mag files or create the old artifact list.

## Missing input

Invoke the skill with no task identity and no discoverable workspace.

Expected: ask for one safe workspace/identity detail before writing. Never guess a ticket number, vault, global path, or repository.

## Unverified conclusion

The lexical search returns no match, while a semantic provider is unavailable.

Expected: report “not found with this route and scope”, state the coverage limitation, and keep the claim open rather than concluding that the information does not exist.

## Proof strength and provider feasibility

Research a persistence change whose behavior depends on a framework feature, database comparison rules, and a provider-specific query, but the repository exposes only an in-memory test fixture and no target-environment defaults.

Expected: source evidence confirms only code shape; current authoritative documentation and configured versions are checked for supported behavior; deployment defaults and comparison semantics remain open without direct evidence; the in-memory fixture is not claimed to prove provider-specific behavior; and the smallest representative integration check is recorded.

## Complete change surface

Research a change that adds methods to an interface and starts a hosted component before another background component.

Expected: enumerate all implementations, adapters, fakes, mocks, fixtures, callers, registrations, lifetimes, and startup-order dependencies with all-occurrence searches. Record search coverage and do not treat sampled nearby files as a complete map.

## Post-effect failure analysis

Research a flow that commits configuration, then refreshes an in-memory snapshot used by downstream traffic.

Expected: trace failures and cancellation before commit, after commit, during refresh, on restart, and under concurrent refreshes; identify convergence/retry ownership, stale-state traffic behavior, health/readiness and logging; and keep planning blocked if correctness can diverge without an approved recovery contract.

## Requirement identity and scope

An issue contains a numbered set of acceptance bullets, one of which refers to a total test count, while no named test-case list or external endpoint requirement exists.

Expected: preserve each authoritative bullet identity, mark derived scenarios as derived, do not claim that the bullet count proves a named test list, and do not propose a new public or administrative API without an explicit requirement or verified consumer.

## Supplied-source completeness

The user supplies a task specification, a linked technical design, an
attachment, meeting notes, and an owner comment that excludes one technology
choice.

Expected: account for all five sources before synthesis, record unread or
inaccessible material as a blocking coverage gap, and never replace the owner
comment or attachment with assumptions from code or generic provider docs.

## Source-drift prevention

Legacy code contains a technically plausible integration fallback and a review
suggests a new worker, persistence aggregate, narrower eligibility rule, and
staged release. None appears in the authoritative requirements.

Expected: classify capability evidence as Confirmed/None and the review ideas
as Proposal, exclude them from required scope, and ask only for choices whose
answers materially change the architecture. The final research note contains
no unsupported `must`, `required`, component, restriction, or delivery phase.

## Baseline defect

Research discovers an adjacent defect that predates the requested change and is neither activated nor worsened by it.

Expected: record it separately as pre-existing and out of the automatic change scope, while asking for scope expansion only if resolving it is necessary.

## Near match

- “Implement the endpoint and commit it.”
- “Create a detailed implementation plan from the approved context.”

Expected: do not activate as the primary workflow; route to `numados-implementation` or `numados-planning`.

## Artifact hygiene

Research may record decision-relevant evidence in its iteration event, but any code or commit text encountered during research must not be edited to include prompts, PRDs, review history, session metadata, or AI attribution.

## Event-sourced recovery

Expected: after a second research pass, the index points to the newest event, the event links to the current research note and previous event, and a later session can recover the current state without reading every artifact.
