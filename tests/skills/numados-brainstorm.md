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

## Near match

- “Implement the endpoint and commit it.”
- “Create a detailed implementation plan from the approved context.”

Expected: do not activate as the primary workflow; route to `numados-implementation` or `numados-planning`.

## Artifact hygiene

Research may record decision-relevant evidence in its iteration event, but any code or commit text encountered during research must not be edited to include prompts, PRDs, review history, session metadata, or AI attribution.

## Event-sourced recovery

Expected: after a second research pass, the index points to the newest event, the event links to the current research note and previous event, and a later session can recover the current state without reading every artifact.
