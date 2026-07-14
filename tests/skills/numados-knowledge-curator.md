# numados-knowledge-curator evaluations

## Activates

- “Save the reusable repository knowledge we learned during this task.”
- “Curate this convention and architecture rationale into the knowledge base.”
- “Use `$numados-knowledge-curator` to analyse the completed work and preserve
  anything that will help future tasks.”

Expected: resolve the configured Obsidian vault and dedicated knowledge root,
extract only reusable candidates, verify them, search for an authoritative note
before writing, and report bounded create/update operations.

Bare `$numados-knowledge-curator` invocation uses the most recent recoverable
completed work in the current project. If that source cannot be identified, it
asks for one task/artifact reference and does not scan unrelated history.

## Duplicate and lifecycle handling

The same convention already exists in one note and an older note conflicts.

Expected: update the authority when appropriate, surface the conflict, and
preview any merge/supersede/retire operation before explicit confirmation. Do
not silently delete or rewrite historical rationale.

## Retrieval and graph quality

Expected: preserve local properties/link style, add only resolved links that
improve future navigation, and prove rediscovery by identifiers, a likely
future question, and one direct relationship. Do not create a note per task,
source, command, or model output.

## Missing configuration and unsafe content

- Vault or `NUMADOS_OBSIDIAN_KNOWLEDGE_ROOT` is unresolved: stop as `BLOCKED`
  or ask for the smallest setup input; never use the task root implicitly.
- Candidate contains a token or machine-local temporary path: exclude the
  sensitive/ephemeral value and retain only safe durable guidance when useful.
- Claim cannot be verified: mark it unresolved or drop it; do not publish it as
  fact.

## Non-activation

- “Write the current task implementation plan” routes to `numados-planning`.
- “Log implementation phase 3” routes to `numados-implementation`.
- “Search my vault for prior tasks” routes to `numados-obsidian-knowledge` or
  `numados-task-navigator`.
- “Explain this architecture” routes to `numados-explain` unless persistence is
  explicitly requested.
