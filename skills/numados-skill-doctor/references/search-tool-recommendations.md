# Search tool recommendations

Recommend a tool only when it closes a requested capability gap. Prefer a ready harness or scoped MCP provider over another installation.

| Capability | Candidate | Recommend when | Do not recommend when | Readiness and cost |
|---|---|---|---|---|
| Fast lexical content | `rg` | no bounded literal/regex provider exists | an applicable bounded harness/MCP search already exists | command identity and target read access; no index |
| Filename discovery | `fd` / `fdfind` | filename-heavy workflows need simpler filters or parallel execution | `rg --files` already meets the workflow | no index; convenience improvement, not semantic recall |
| Structural code | `ast-grep` | queries concern syntax, calls, declarations, or AST relationships | work is plain text/Markdown or exact identifiers suffice | verify output explicitly identifies ast-grep; short `sg` names may collide |
| Extracted documents | `rga` | PDF, Office, archives, media metadata, or SQLite must be searched | content is plain text/Markdown | verify required adapters; may need Pandoc, Poppler, FFmpeg, or format-specific processing |
| Markdown semantic | existing harness retrieval or QMD | conceptual queries recur and lexical ranking is weak | exact queries dominate or a ready harness semantic provider already covers the root | confirm scope, privacy, index freshness, model downloads, disk, and maintenance |
| Machine-wide filename index | `plocate`-like provider | repeated searches span very large approved roots | searches stay inside a few repositories | verify database scope/freshness; background indexing exposes filename metadata and needs maintenance |
| Filesystem MCP | scoped MCP server | shell access is unavailable or a strict root boundary is required | local `rg` is ready and the MCP cannot access the target | inspect allowed roots, content mode, exclusions, output bounds, and protocol overhead |
| Parallel execution | harness subagent | independent roots or provider branches are expensive and mergeable | one bounded query is faster inline | no installation; extra startup, tokens, and result-merging cost |

## Recommendation format

For each relevant gap, report one primary candidate:

```text
- <capability>: <candidate> — benefit; readiness proof; setup/index/privacy cost
```

Do not print a generic shopping list. Do not provide an install command until the user asks to change the machine and current official OS-specific instructions have been verified.

Primary references:

- ripgrep: https://github.com/BurntSushi/ripgrep
- fd: https://github.com/sharkdp/fd
- ast-grep: https://ast-grep.github.io/guide/
- ripgrep-all: https://github.com/phiresky/ripgrep-all
- QMD: https://github.com/tobi/qmd
