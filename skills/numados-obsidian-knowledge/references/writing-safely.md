# Writing safely

## Choose create versus update

Before writing, search the proposed title, aliases, and subject. Update an existing note when it is already authoritative for the information. Create a new note only when the content has a distinct identity or lifecycle.

Do not invent a universal folder taxonomy. Select the destination from:

1. An explicit user path.
2. `NUMADOS_OBSIDIAN_WRITE_ROOT`.
3. A clear convention demonstrated by neighboring notes.

Ask when these sources disagree or none applies.

## Properties

Properties are YAML frontmatter at the top of a note. Preserve existing property names and types across the vault. Keep values atomic and machine-queryable; put paragraphs and rationale in the body.

Obsidian supports text, lists, numbers, checkboxes, dates, date-times, and tags. Property names must be unique within a note. Quote internal links stored in YAML:

```yaml
---
title: Example
aliases:
  - Alternate name
related:
  - "[[Another note]]"
updated: 2026-07-13
---
```

Do not add empty properties merely for schema uniformity. Do not introduce nested properties when Obsidian-native editing and querying matter.

## Links

Honor `NUMADOS_OBSIDIAN_LINK_STYLE`:

- `preserve`: inspect nearby notes and retain their style.
- `wikilink`: use `[[Note]]`, with heading or display text only when useful.
- `markdown`: use standard internal Markdown links with correctly encoded paths.

Use normal Markdown links for external URLs. Resolve an internal target before adding the link. Avoid links added solely to make the graph denser.

## Mutations

- Create with full intended content and refuse accidental overwrite.
- Patch existing notes using stable headings or exact surrounding text.
- Re-read immediately before editing if another process may change the vault.
- Prefer native Obsidian CLI for move and rename because it can update internal links according to vault settings.
- Show a proposed file list before bulk metadata, link, move, rename, or delete operations.
- Never mutate `.obsidian/` or plugin state as part of ordinary note storage.

## Git boundary

Git does not change the write procedure. Finish content validation first and always report the exact vault-relative paths touched by the current request. Only after an explicit commit request may those paths be handed to the active commit workflow. Never include unrelated working-tree or index changes, and never push implicitly.

This storage skill does not define commit-message conventions. Repository, user, or shared toolkit contracts own that policy.

## Provenance

When the stored information comes from an external source, retain enough context to find it again: source path or URL, capture date when relevant, and whether the text is quoted, summarized, or inferred. Do not represent an agent inference as source fact.
