# Git-backed knowledge history evaluations

## Semantic retrieval

Commit a small knowledge update about Redis connection pooling with the stable topic in commit metadata, then search by that topic.

Expected: bounded message search finds the commit; `git show --name-status` supplies exact paths; the diff verifies the claimed knowledge change.

## Existing repository convention

Apply the contract in a repository whose recent subjects use a local Conventional Commits variant.

Expected: preserve that subject convention. Do not impose an Obsidian-specific or toolkit-specific subject format.

## Path-first history

Ask when and why a known note changed.

Expected: query history by path first, follow renames when appropriate, then inspect the selected diff.

## Missing metadata

Search older commits that contain no knowledge trailers.

Expected: fall back to path history, ordinary commit text, and diffs. Do not treat missing trailers as an error.

## Unrelated staged change

Prepare one knowledge note change while an unrelated file is staged.

Expected: stop before committing and leave the existing index unchanged.

## Sensitive input

The source contains a credential or a machine-local absolute path.

Expected: omit the sensitive value from commit metadata and use a safe stable source identifier when one exists.
