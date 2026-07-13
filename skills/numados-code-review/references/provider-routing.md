# Review source routing

Read this reference only when the review source must be retrieved from a URL, remote identifier, or repository host.

## Identify the provider

Use URL structure as evidence, not the user's wording:

| URL signal | Provider family | Review object |
|---|---|---|
| `github.com/.../pull/<id>` or a compatible host with `/pull/` | GitHub-compatible | pull request |
| `dev.azure.com/.../_git/.../pullrequest/<id>` or `*.visualstudio.com/.../_git/.../pullrequest/<id>` | Azure Repos | pull request |
| `.../-/merge_requests/<id>` | GitLab-compatible | merge request |
| `bitbucket.org/.../pull-requests/<id>` or a compatible host | Bitbucket-compatible | pull request |

For an unfamiliar host, inspect the URL and current repository remotes. Do not force it into a known family. If an identifier has no URL, infer the provider only when the current repository remote or active harness makes it unambiguous; otherwise ask for the URL.

## Select an installed reader

Choose the first ready, target-applicable option:

1. A harness, app, or MCP integration that exposes review metadata and patch content.
2. An authenticated provider CLI already installed for that forge.
3. A local Git worktree with the exact base and head objects available.
4. A read-only web source that exposes the complete changed files and patch.

Command presence alone does not prove readiness. Confirm that the provider supports the detected forge, can access the target, and requires no new authentication or mutation. Tool names and invocation syntax belong to the active harness or adapter, not this portable skill.

## Retrieve bounded evidence

Read only what the review needs:

1. title, description, base/head, and changed-file list;
2. patch or exact base/head file versions;
3. linked requirement or work item when it defines expected behavior;
4. discussion or CI results only when they affect a candidate finding.

Do not enumerate unrelated repositories or organization data. If provider output is truncated, reconstruct the affected files from exact base/head objects or ask for the missing patch.
