# Change artifact hygiene

## Ownership

- Owner: numados toolkit
- Scope: source code, code comments, tests, generated change descriptions, and commit messages produced while implementing a change
- Applies independently of language, repository host, issue tracker, review system, or agent harness

## Principle

A durable artifact must describe the software or knowledge state that maintainers need after the change. Do not preserve the temporary process that produced it.

## Source code and comments

- Keep identifiers, strings, comments, and documentation focused on product behavior, domain meaning, public contracts, non-obvious invariants, compatibility constraints, or maintainable implementation rationale.
- Prefer code that explains itself. Add a comment only when the reason, constraint, or safety invariant cannot be expressed clearly in code.
- Do not mention an AI model, agent, prompt, conversation, session, PRD, task discussion, review recommendation, reviewer, implementation plan, or “as requested” history.
- Do not add issue, PRD, review, or task URLs to source comments. A durable external standard or protocol reference is allowed only when the implementation directly depends on it and the repository accepts such references.
- Do not leave transient debugging notes, review replies, speculative TODOs, or copied planning text in production code or tests.

## Commit messages

- Describe only the resulting behavior, contract, configuration, test, documentation, or operational change and the durable reason when it is not obvious from the subject.
- Do not include AI attribution, co-author metadata for an AI tool, prompts, session details, PRD or review links, reviewer recommendations, implementation-plan narration, or validation theater.
- A compact work-item identifier may appear only when repository policy requires it and it directly identifies the change. Do not copy the work-item URL or its process history.
- Do not repeat file lists or diff details that Git already records. Keep unrelated concerns in separate commits.

## Exceptions

Process metadata belongs in an artifact only when that artifact's explicit product purpose is to store or exchange that metadata. Repository-required license headers, generated-code markers, and durable protocol references remain valid; they must not identify an AI authoring process.

## Verification

Before completing a code change or generating a commit message:

1. Inspect new and modified comments, documentation, identifiers, and user-visible strings.
2. Remove process provenance that a future maintainer does not need to understand or operate the code.
3. Verify that every remaining reference is directly required by the changed behavior or repository policy.
4. Confirm the commit message is supported by the selected diff and contains no unrelated narrative.
