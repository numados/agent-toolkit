# Git-backed knowledge history

## Ownership

- Owner: numados toolkit
- Scope: commits that modify file-based knowledge, memory, research, or reference storage under Git
- Applies independently of storage format or the skill that performed the write

## Purpose

Make version history useful to both humans and agents without duplicating the Git diff in the commit message. A later reader should be able to discover a relevant commit by topic or stable reference, understand why knowledge changed, and then recover the exact files and content from Git.

## Commit boundary

- Commit only after an explicit user request.
- Inspect the worktree, index, and recent repository history before composing the commit.
- Preserve the repository's active subject convention and higher-priority user or repository instructions.
- Stage only paths owned by the completed operation. Stop when unrelated staged changes make that boundary uncertain.
- Never initialize a repository or push as an implicit consequence of storing knowledge.

## History metadata

The subject must describe the semantic knowledge change, not merely say that files or notes were updated. Keep exact filenames out of the subject unless a filename is itself the stable concept users will search for.

Include at least one stable retrieval term when one exists: a topic, system name, ticket, document ID, source, or related reference. Use the body only when the subject cannot explain the outcome and reason. Add compact Git trailers when they improve retrieval:

```text
Knowledge-Topic: <stable topic, identifier, or system name>
Source-Ref: <URL, document ID, commit, issue, or other provenance>
Related-Ref: <related stable identifier>
```

Each key may be repeated. Omit unknown or low-value metadata instead of inventing it. Never include secrets, credentials, private conversation text, or machine-specific absolute paths.

The commit message does not need to repeat every changed path. Git already records exact locations and content. Keep commits narrowly scoped so a later agent can recover them with:

```bash
git log --fixed-strings --regexp-ignore-case --grep='<topic-or-ref>'
git log --follow -- <path>
git show --name-status <commit>
git show <commit> -- <path>
git show -s --format=%B <commit> | git interpret-trailers --parse
```

## Retrieval procedure

1. Search by a known path when available; this is more precise than message search.
2. Otherwise search commit text for a stable topic, source, ticket, document ID, or related reference.
3. Read the selected commit's subject, body, and trailers.
4. Obtain exact added, modified, renamed, and deleted paths from `git show --name-status`.
5. Verify the claim against the actual diff or file snapshot before using it as knowledge evidence.

## Compatibility impact

Trailer keys are additive and use Git's standard trailer syntax. Existing repository subject rules remain authoritative. Consumers must continue to work when a commit has no trailers, because older and externally authored history may be unstructured.

## Verification

- A topic or stable reference finds the intended commit with bounded `git log --grep`.
- `git show --name-status` identifies where the change occurred without relying on prose.
- The diff supports the semantic claim in the subject or body.
- No unrelated path is included in the commit.
- No absolute machine path or sensitive value appears in the message.

## Upstream references

- Git commit: https://git-scm.com/docs/git-commit
- Git log: https://git-scm.com/docs/git-log
- Git show: https://git-scm.com/docs/git-show
- Git trailers: https://git-scm.com/docs/git-interpret-trailers
