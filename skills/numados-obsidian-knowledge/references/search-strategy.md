# Search strategy

## Retrieval pipeline

Use staged retrieval so cost grows with ambiguity rather than vault size.

### 1. Normalize intent

Extract stable nouns, exact phrases, identifiers, likely aliases, spelling variants, and language variants from the request. Keep the original query; expansions supplement it rather than replace it.

### 2. Locate cheaply

Search in this order:

1. Exact vault-relative path.
2. Filename or basename.
3. `title` and `aliases` properties.
4. Exact phrase in note content.
5. All important terms in note content.

Return candidate paths before bodies. For filesystem search, use `scripts/vault-search.sh --mode auto --query <query>`. Narrow with `--scope` whenever a relevant root is known.

### 3. Use structured search

When native Obsidian CLI is available, pass Obsidian Search syntax directly:

```bash
obsidian search query='"exact phrase"' limit=20
obsidian search query='path:"Architecture" [status:active]' limit=20
obsidian search:context query='tag:#decision content:"rate limit"' limit=20
```

Useful operators include `file:`, `path:`, `content:`, `tag:`, `line:`, `block:`, `section:`, task operators, property filters such as `[status:active]`, `OR`, negation, parentheses, exact phrases, and JavaScript-style regular expressions.

### 4. Inspect bounded evidence

For up to roughly 10–20 candidates:

1. Inspect path, properties, headings, and one or two matching snippets.
2. Rank exact title/alias and exact phrase matches above loose term matches.
3. Read the full body only for the top few candidates.
4. Preserve source paths and line or heading anchors for citation.

### 5. Expand through links

After identifying a strong note, inspect its outgoing links and backlinks. Expand one hop, score those notes against the original query, and stop unless the next hop adds new evidence.

With Obsidian CLI:

```bash
obsidian links path="Folder/Note.md"
obsidian backlinks path="Folder/Note.md" format=json
obsidian unresolved format=json
```

Without it, search wikilink text as a candidate generator, but do not claim complete backlinks: aliases, Markdown links, duplicate basenames, headings, and Obsidian resolution rules make regex-only graph reconstruction approximate.

### 6. Escalate to semantic search

Use semantic search only when the user asks by concept, terminology may differ, or lexical passes produce weak results. If an approved QMD collection exists, inspect `qmd status` first. Do not run `vsearch` or `query` until model availability is proven or the user approves any first-use download:

```bash
qmd search "exact keywords" -c <collection> --json -n 10
qmd vsearch "conceptual description" -c <collection> --json -n 10
qmd query "question in natural language" -c <collection> --json -n 10
```

Open and verify returned Markdown. Semantic score indicates relevance, not truth or authority.

### 7. Inspect version history when requested

If the vault is inside a Git worktree and the question concerns provenance or change history, locate the current note first and then query only its bounded history:

```bash
git -C <vault> log --follow --oneline -n 20 -- <vault-relative-path>
git -C <vault> show --stat --oneline <commit>
git -C <vault> show <commit> -- <vault-relative-path>
```

Search commit messages only when no path is known or the query names a stable identifier. Use the resulting commit to discover candidate paths, then inspect the actual diff. Do not load the complete repository history into context.

## Search quality rules

- Prefer several narrow queries over one broad context dump.
- Search both terminology and known aliases.
- Keep directory scope explicit in result reporting.
- Treat duplicate basenames as ambiguous until paths are resolved.
- Treat no matches as “not found with these queries and scope”.
- Do not search `.obsidian/`, `.git/`, binary attachments, or caches by default.
- Do not treat a commit message as proof of note content; verify the Markdown diff.
- Cite synthesized answers with vault-relative paths and line or heading anchors.

## Upstream references

- Obsidian CLI: https://obsidian.md/help/cli
- Obsidian Search syntax: https://obsidian.md/help/plugins/search
- Obsidian Properties: https://obsidian.md/help/properties
- Obsidian internal links: https://obsidian.md/help/links
- QMD local hybrid search: https://github.com/tobi/qmd
