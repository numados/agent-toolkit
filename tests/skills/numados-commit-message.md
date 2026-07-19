# numados-commit-message evaluations

## Staged scope wins

Stage a focused fix while leaving unrelated documentation unstaged.

Expected: generate a message only for the staged fix and do not include the documentation.

## No staged files

Leave one coherent implementation unstaged and ask for a message for the current changes.

Expected: use the unstaged diff and mention that assumption only if needed to prevent surprise.

## Ambiguous mixed state

Stage half of one logical change while the same files contain additional unstaged hunks.

Expected: ask one precise scope question before generating the message.

## Provider-neutral work item

Use repositories linked to Jira, Azure Boards, GitHub Issues, and an unfamiliar tracker in separate runs.

Expected: preserve each repository's observed identifier style. Do not assume tracker-specific syntax or require a particular provider.

## Work-item context is input, not output

Supply a PRD URL, issue description, review recommendation, and implementation-plan text that helped explain the diff.

Expected: use relevant context to understand intent but omit all URLs and process narrative. Describe only the resulting change. Preserve a compact work-item identifier only when repository policy requires it.

## Repository format precedence

Recent history uses a custom subject format that conflicts with Conventional Commits.

Expected: follow repository instructions/history. Use Conventional Commits only when no stronger convention exists.

## Subject-only atomic outcome

Select a diff with one atomic behavioral outcome that the subject communicates completely.

Expected: a subject-only message is acceptable; do not add a body that merely repeats the subject.

## Multiple behavioral outcomes require a body

Select a coherent diff that both propagates a field through public outputs and rejects contradictory input.

Expected: preserve the repository subject convention and add concise bullets for both durable outcomes. Do not omit the body merely because recent commits are subject-only.

## Amend uses the complete future commit

Start with an existing commit that changes event propagation, then stage a related validation fix and request an amended message.

Expected: inspect the parent-to-index result and generate a message covering both outcomes, not only the staged validation delta.

## Atomicity

The selected diff contains an API feature and an unrelated deployment rewrite.

Expected: recommend splitting rather than hiding both under a broad subject.

## Missing Git capability

Ask for a message in an inaccessible worktree with no diff supplied.

Expected: request the intended diff. Never invent a message from filenames or branch name alone.

## No mutation

Ask only for a message.

Expected: return paste-ready text without staging, committing, pushing, formatting, or modifying files.

## No AI or review attribution

Ask for a message after an agent implemented review feedback.

Expected: do not mention the agent, AI, prompt, review, reviewer, recommendation, session, or “as requested.” The message describes only the resulting behavior and durable reason.
