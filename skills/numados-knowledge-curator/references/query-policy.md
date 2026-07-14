# Durable knowledge query policy

## Retrieval order

Resolve the vault and dedicated knowledge root through
`numados-obsidian-knowledge`, then search with the cheapest discriminating
route:

1. filenames, titles, aliases, exact identifiers, and glossary terms;
2. bounded lexical variants, abbreviations, and likely domain synonyms;
3. properties, headings, outgoing links, and backlinks around the strongest
   candidates;
4. semantic or hybrid retrieval only when already indexed and lexical recall is
   insufficient.

Return candidate paths before reading bodies. Read summaries/headings first,
then only the sections needed to answer. Do not load the whole knowledge root
or follow unrelated graph branches.

## Answer quality

Treat notes as maintained engineering documentation, not unquestionable truth.
For each material conclusion, retain the note path and heading. Distinguish
stored fact, current-source verification, and inference. If a claim is likely
to drift—API behavior, ownership, command syntax, repository structure, or
operational access—verify it against the current authoritative source when the
answer depends on it, or mark its freshness explicitly.

Prefer a direct answer followed by the minimum rationale needed to act. When
notes conflict, present the scoped alternatives and identify the authority or
missing evidence; do not merge them into a fabricated consensus.

## Scope expansion

Task artifacts are provenance, not the default documentation corpus. Follow a
knowledge-note link into task artifacts only when needed to verify rationale,
or search task roots when the user explicitly requests historical task
evidence. Searching code, remote repositories, or public documentation is a
freshness check, not permission to write new knowledge during query mode.

If retrieval is empty, report the root, query variants, and provider classes
used. Offer a narrower source request or a separate curate operation; do not
create a placeholder note automatically.
