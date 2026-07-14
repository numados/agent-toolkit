# Vault context

## Profile model

Separate portable project selection from machine-specific paths:

```text
project/.numados/obsidian-profile
    contains: btcs

${XDG_CONFIG_HOME:-~/.config}/numados/obsidian/profiles/btcs.env
    contains: NUMADOS_OBSIDIAN_VAULT=/path/on/this/machine
```

The project marker contains only a logical profile name and may be committed. Each machine maps that name to its own absolute path. The nearest marker found while walking from the working directory toward the filesystem root wins, so a nested project can select a different vault.

Create a profile and associate it with a project:

```bash
scripts/configure-vault.sh \
  --profile btcs \
  --vault /absolute/path/to/vault \
  --project /absolute/path/to/project
```

Add `--default` to make the profile the machine-wide fallback. Use `--force` only to intentionally rebind a project that already selects another profile.

Update only selected fields of an existing profile:

```bash
scripts/configure-vault.sh \
  --profile btcs \
  --update \
  --knowledge-root knowledge \
  --backend filesystem \
  --search-roots knowledge,decisions
```

Unspecified values, including the vault path and write root, are preserved. Without `--update`, attempts to change an existing profile fail. `--force` does not replace profile settings; it only permits rebinding an existing project marker to another profile.

Bind an existing profile without editing it:

```bash
scripts/configure-vault.sh --profile btcs --project /path/to/project
```

## Resolution precedence

Resolve deterministically in this order:

1. Explicit `--vault`.
2. Explicit `--config` or `--profile`.
3. `NUMADOS_OBSIDIAN_VAULT` or `NUMADOS_OBSIDIAN_PROFILE` for the current process.
4. Nearest `.numados/obsidian-profile` from the current working directory upward.
5. Machine default in `${XDG_CONFIG_HOME:-~/.config}/numados/obsidian/default-profile`.
6. Legacy `${XDG_CONFIG_HOME:-~/.config}/numados/obsidian-knowledge.env`.
7. Stop and ask for configuration.

Inspect the decision without modifying anything:

```bash
scripts/resolve-vault.sh --show-context
scripts/validate-vault-context.sh
```

Use `--start-dir` when resolution must be evaluated as if the agent were working in another directory.

## Profile fields

Profile files accept simple `KEY=value` entries:

- `NUMADOS_OBSIDIAN_VAULT`: required absolute vault path.
- `NUMADOS_OBSIDIAN_WRITE_ROOT`: optional existing directory relative to the vault.
- `NUMADOS_OBSIDIAN_KNOWLEDGE_ROOT`: optional existing directory for reusable,
  cross-task engineering knowledge. It may differ by project profile.
- `NUMADOS_OBSIDIAN_SEARCH_ROOTS`: optional comma-separated search scopes relative to the vault.
- `NUMADOS_OBSIDIAN_SEARCH_BACKEND`: `auto`, `filesystem`, `obsidian`, or `qmd`.
- `NUMADOS_OBSIDIAN_QMD_COLLECTION`: collection name when QMD is explicitly enabled.
- `NUMADOS_OBSIDIAN_LINK_STYLE`: `preserve`, `wikilink`, or `markdown`.

Configuration is parsed as data and never sourced. Do not put secrets in it.

The skill may create or edit these files after an explicit setup request. It must use `configure-vault.sh`, validate the result, and report the profile and project marker changed. A one-off explicit vault path must not be persisted automatically.

## Backend routing

`auto` means: begin with filesystem search, then use Obsidian-native or semantic search only when the query needs capabilities they provide and the backend is already available. It does not install tools or launch applications automatically.

### Filesystem

Use as the portable baseline. It works offline and headless, has no index to maintain, and is usually sufficient for exact identifiers, phrases, filenames, and small-to-medium vaults. Prefer `rg --files` and `rg -l` candidate discovery before showing snippets.

### Obsidian CLI

Use for Obsidian-native search operators, properties, tags, aliases, backlinks, unresolved links, and link-aware move/rename. It requires a compatible Obsidian installation and the app context. Do not launch a GUI unexpectedly; confirm availability before selecting it.

Run `obsidian help` before relying on a command. At the time this skill was authored, the official CLI documentation requires the Obsidian 1.12.7+ installer and states that the app must be running or will be launched by the first command.

### QMD

Treat QMD as optional. Use it when exact lexical search misses conceptually related notes or when repeated large-vault retrieval justifies maintaining an index. Prefer keyword search first, then vector or hybrid/reranked query. Verify every semantic result against the source Markdown because relevance is probabilistic.

Do not install, index, or download models merely because QMD is absent. `qmd vsearch` and `qmd query` may need first-use model downloads; verify readiness with `qmd status` and ask before any download or index mutation.

## Portability

Keep machine paths in profile files outside the distributed skill and project repository. The skill must remain useful with filesystem access alone. MCP file tools may replace shell operations when they expose bounded search, read, patch, and vault-root sandboxing; preserve the same workflow and safety checks.
