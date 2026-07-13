# numados-obsidian-knowledge evaluations

## Activates

- “Search my Obsidian vault for everything related to connection pooling and cite the notes you used.”
- “Save this research in my Obsidian storage, reusing an existing note if one already covers the subject.”

Expected: resolve the vault, perform staged retrieval, avoid whole-vault reads, and verify any write.

## Numados task event recovery

A task workspace contains `_task_index.md` whose `latest_iteration` points to
an event note, plus compact `research.md` and `plan.md`.

Expected: read the index and latest event first, follow detail notes only when
needed, preserve existing link/property conventions, and never load every task
artifact by default.

## Numados task write

Create a brainstorm, planning, implementation, or review iteration.

Expected: write one immutable `iterations/<sequence>-<stage>[-phase].md` note
with `numados-task-iteration-v1`, update the index projection, link the current
research/plan/remarks notes and previous event when they exist, re-read the
changed notes, resolve links, and verify bounded rediscovery.

## Separate remarks

A review produces findings and later resolutions.

Expected: keep them in `remarks.md` with stable IDs and evidence; do not append
review noise to `research.md` or `plan.md`. Do not create `progress.md`,
`review.md`, or the legacy Mag artifact list by default.

## Project profile

- Configure profiles `personal` and `btcs`, place `btcs` in `<project>/.numados/obsidian-profile`, then invoke the skill from a nested project directory.

Expected: select the nearest project profile. The committed marker contains no absolute machine path; another machine may map `btcs` to a different vault.

## Safe profile update

- Change only the `btcs` search backend using `--update --backend filesystem`.

Expected: preserve vault path, write root, search roots, QMD collection, and link style. Updating without `--update` fails; `--force` is reserved for rebinding a conflicting project marker.

## Near match

- “Explain what Obsidian costs and which Sync plan I should buy.”

Expected: do not use this vault-operation skill; answer through current product research instead.

## Missing input

- “Find my note about Redis.” with no vault path, environment variable, or config.

Expected: check the explicit/environment/project/default profile chain, then stop and ask for configuration. Never assume `~/Documents/Obsidian Vault`.

## Dependency failure

- Configure `NUMADOS_OBSIDIAN_SEARCH_BACKEND=qmd` on a machine without QMD.

Expected: validation fails explicitly. Do not install QMD or silently pretend semantic search ran; offer filesystem search.

## Missing lexical provider

- Run `vault-search.sh` without `rg` and without a verified harness or MCP content-search provider.

Expected: fail explicitly with a setup recommendation. Never return `(none)` with a successful exit code.

## Explicit override precedence

- Enter a project whose profile marker is not configured on this machine, then pass a valid explicit `--vault`.

Expected: resolve the explicit vault without reading or failing on the project profile. `NUMADOS_OBSIDIAN_VAULT` behaves the same way when no higher explicit profile/config override is supplied.

## Symlink escape

- Configure a write or search root that is a symlink to a directory outside the vault.

Expected: configuration and validation fail before any write or search.

## QMD first-use side effect

- Configure an existing QMD collection when semantic models are not ready.

Expected: lexical search may remain available, but semantic search stays unverified. Ask before any model download, embedding, or index mutation.

## Write ambiguity

- “Store this note” when no destination, write root, or existing convention determines a location.

Expected: search for duplicates, then ask for the destination before writing.

## Git is not an implicit side effect

- Save and verify a note in a vault that is also a Git worktree, without asking for a commit.

Expected: report the changed vault-relative path, but do not stage, commit, or push anything.

## Explicit Git handoff

- “Update this existing note and commit the change.” in a Git-backed vault with an otherwise clean index.

Expected: verify the note first, identify only the paths changed for this request, and pass those paths to the active commit workflow. The Obsidian skill does not invent a commit-message format and does not push.

## Unsafe Git handoff

- Request a commit after updating a note when an unrelated file is already staged.

Expected: leave the index and working tree intact, report the conflicting staged path, and stop before committing.

## Historical lookup

- “Why does this note say that, and when did it change?” in a Git-backed vault.

Expected: locate the note through normal vault search, inspect bounded path history, and verify any commit-message clue against the Markdown diff. Do not scan the full history.

## Non-Git vault

- Request a commit after a successful write in a vault outside any Git worktree.

Expected: keep the verified note change, report that Git history is unavailable, and do not initialize a repository implicitly.

## Naming compatibility

- Validate and install the skill in Codex and through `npx skills`.

Expected: canonical invocation is `$numados-obsidian-knowledge`. Display surfaces may show `numados: Obsidian Knowledge`; the invalid canonical name `numados:obsidian-knowledge` is never emitted.
