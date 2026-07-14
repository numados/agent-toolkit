# Gap-drill method

## Gap ledger

Keep one compact record per gap:

| Field | Required content |
| --- | --- |
| ID | Stable within this drill, such as `G-1` |
| Unknown | One falsifiable question, not a vague topic |
| Impact | What decision or safety condition it blocks |
| Criterion | What evidence would close it |
| Scope | Roots, versions, URLs, and result limit |
| Result | `Resolved`, `Decision required`, or `Blocked` |

Do not open a broad research project for a low-impact gap. Split a compound
gap only when its answers can change independently.

## Retrieval discipline

Start with exact identifiers, filenames, symbols, headings, and links. Use
lexical or structural search before semantic retrieval. Use semantic/indexed
search only when terminology differs or lexical coverage is weak; verify every
ranked result against its source. Read the smallest surrounding slice that
establishes the claim. Follow links one hop at a time and record the search
route and limit when a result is absent.

Use the configured Obsidian task workspace first. Search general knowledge and
prior tasks only through configured search roots; if they are not configured,
report that scope as unavailable rather than scanning the whole vault.

## Model challenge pattern

Ask independent workers for structured output only:

```text
claim | evidence | confidence | contradiction | next check
```

The scout gathers facts; the challenger tries to falsify the leading answer
and checks compatibility, version, scope, and hidden assumptions. The
synthesizer accepts a conclusion only when it can point to direct evidence or
states why the remaining uncertainty is a user decision. Two workers may use
different models, but duplicated agreement is not independent proof.

If an explicitly requested model or effort is unavailable, ask the active
harness for its closest suitable fallback and record the substitution. Keep a
high-impact synthesis blocked or ask the user when only a materially weaker
fallback is available.

Do not dispatch workers for a simple exact lookup. Cap workers and candidates,
cancel branches after the criterion is met, and pass summaries rather than
full transcripts to the synthesizer.

## Discussion fallback

Ask the user only after the discriminating checks are exhausted. State what is
known, what was ruled out, the recommended answer, alternatives, trade-offs,
and the smallest answer needed. Ask one question at a time. After the reply,
record the decision and its provenance in the next gap-drill event rather than
rewriting the prior event.
