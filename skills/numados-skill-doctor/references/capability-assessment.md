# Capability assessment

## Provider proof

A provider satisfies a capability only when all four checks pass:

1. **Discovery**: the command or harness/MCP tool is present.
2. **Scope**: it can access the target root; server-wide availability is insufficient.
3. **Operation**: it supports the needed mode, such as literal content search rather than filename-only search.
4. **Readiness**: use will not trigger unapproved installation, indexing, model download, GUI launch, daemon, or mutation.

Caller-provided `harness:*` and `mcp:*` capabilities are assertions from the active agent. Pass them to the probe only after checking the current tool registry and target scope. When introspection is unavailable, report `unknown`, not `missing`.

## Search efficiency

Evaluate search routes independently:

| Query class | Strong provider | Efficient behavior |
|---|---|---|
| Filename/path | `rg --files`, `fd`, or bounded filesystem MCP | Return candidate paths only |
| Exact text | `rg -l` or bounded content-search MCP | Locate files, then show short snippets |
| Properties/links | Native storage query or graph-aware MCP | Query structured fields without whole-vault scans |
| Conceptual | Maintained semantic/hybrid index | Return top-K paths and scores; verify source text |
| History | Git or storage-native history | Query a known path before broad message search |

`rg` is a strong no-index baseline for Markdown. A scoped content-search MCP is equivalent only if it supports literal or regex search, file filtering, bounded output, and the target root. Code-oriented semantic retrieval does not automatically qualify for generic Markdown vault search.

An indexed provider is worthwhile when conceptual queries are frequent, terminology differs, or lexical candidate sets are too large. Include index freshness, disk use, model downloads, privacy boundary, and maintenance in the recommendation.

## Installation policy

Recommend installation only when no ready provider satisfies a required operation or a requested optional feature has a clear benefit. Prefer this order:

1. Already-ready harness capability.
2. Already-ready scoped MCP capability.
3. Small local CLI with no persistent service or index.
4. Native application integration.
5. Indexed or model-backed provider.

Name the missing capability and recommended provider first. Provide an OS-specific command only after verifying current official installation documentation and receiving approval to change the machine.

Primary references:

- Agent Skills scripts: https://agentskills.io/skill-creation/using-scripts
- ripgrep: https://github.com/BurntSushi/ripgrep
- Obsidian CLI: https://obsidian.md/help/cli
- QMD: https://github.com/tobi/qmd
