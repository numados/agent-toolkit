---
name: numados-clear-report
description: >
  Produce a concise structured report for a named reader from supplied code, architecture, pull requests, logs, configuration, documents, or business requirements—either an orientation map of the material, not a tutorial, or a write-up that carries a finished conclusion. Use when the user asks what something is, what it contains, or how it fits, or when a decided outcome must be communicated to a non-implementing requester, product owner, or stakeholder: what happened, why the obvious fix cannot work, what is proposed instead. Do not use for step-by-step teaching, debugging, implementation, review, search, or task navigation.
---

# Numados Clear Report

Give the reader a fast, accurate orientation of the material, or the conclusion the material already carries. Either way this is a map, not a tutorial. Reply in the conversation's language; preserve exact technical and business terms when precision matters, and translate them at first use.

## Ground the report

Read the supplied material before reporting it. For a code path, inspect the relevant source. For a PR, document, log, configuration, or requirement, use the supplied artifact and only the relevant surrounding context. If an essential source is inaccessible, ask for that source in one precise sentence instead of guessing.

Keep these states distinct:

- **Fact** — directly supported by the supplied source or authoritative documentation.
- **Conclusion** — a bounded conclusion derived from stated facts.
- **Unknown** — information that materially affects the report but is unavailable.

Never invent file contents, dependencies, business rules, metrics, or examples. Mark any hypothetical example explicitly.

## Name the reader before writing

State who reads this and what they will do with it. The same findings produce different reports, and choosing the wrong reader is the most common failure.

- **Non-implementing reader** — a requester, product owner, or stakeholder who decides, not codes. Outcome, mechanism, consequence. No file:line, no exception or class names, no test plans.
- **Implementing reader** — an engineer who picks the work up. File:line, identifiers, and reproduction details belong in the text.

Length follows the reader's decision, never the size of the investigation. The volume of evidence gathered must not leak into the length delivered.

## Output contract

Use only sections that contain useful information. Collapse empty sections. Default to roughly 150–200 words for an orientation report, and 150–250 for one that must carry a conclusion. Exceeding the budget needs a stated reason — material whose structure collapses under further compression — and being thorough is not one.

Render these headings in the conversation's language. The English labels below describe the default sections:

```text
## What it is
Material type and purpose in 1–2 sentences.

## Why it exists
Problem or goal it serves.

## Main parts
3–7 most important elements, actors, or responsibilities.

## How it works or fits
Only the main data/control flow or relationship between elements.

## What matters
One or two boundaries, risks, entry points, decisions, or practical consequences.

## Unknowns
Only material gaps; include the evidence needed to resolve them.
```

Start with the essence, not background. Prefer bullets over paragraphs. Use a table only for several exact mappings or a real comparison — never where one number carries the point. Use a flow only when at least three components, branches, or state transitions are harder to follow in prose. Do not add analogies, a deep dive, exhaustive file lists, generic praise, or recommendations unless requested.

## When the report carries a conclusion

Some material has an answer in it: a change failed, a proposed fix cannot work, a number moved. Then the sections above give way to the reader's decision path — what happened → why the obvious fix cannot work → what to do instead → what that will not fix. Chronology and investigation order are not orderings.

- **Put the conclusion in the heading.** A reader who stops after the title still has the answer: "the check was released and rolled back — it validates the wrong object", not "check investigation results".
- **One number per claim, and make it the decisive one.** Give the ratio with its raw pair — `40% (2114 of 5294)` — so it is interpretable and verifiable at once. A second supporting number weakens the first.
- **Explain a mechanism as a chain of short checkable clauses that ends in an absurdity the reader judges instantly.** Every link is independently verifiable, so the conclusion needs no argument: *we send the item already booked → we ask the provider to find a cheaper one → the cheaper one exists only in its response → the check validates what we sent, before pricing → so we asked whether the item we already own can be sold to us again.*
- **Reframe the decisive technical fact as a plain-language question the reader can judge without domain knowledge**, and make it the chain's last clause. This is usually the highest-leverage sentence in the report; find it deliberately.
- **One fully instantiated example, never a set.** Real identifiers and the exact message let the reader verify the claim; five instances of one pattern only demonstrate diligence.
- **State each proposal as action → effect on one line**, not as a design description: "treat the failure as an expected outcome → the error-log noise disappears".
- **Name the limitation yourself and say why it is unavoidable.** End on it rather than burying it. A hole the reader finds that you already knew about costs more credibility than the hole.

## Cut before returning

Apply to every sentence: if the reader never saw it, would they decide or act differently? If not, delete it. True, measured, hard-won, and interesting are not reasons to keep it.

Delete on sight:

- Anything included to prove how much was examined rather than to change a decision.
- A per-requirement compliance matrix where one sentence settles it.
- Mechanics the reader does not need in order to act.
- The second and third example of a pattern the first example already showed.

Then tell the requester what was cut — one line naming the removed items, in the reply and not inside the report. It keeps the cut reversible and shows it was a choice, not an omission.

## Routing boundary

If the user says they do not understand, asks to unpack **how** or **why**, or asks for a step-by-step explanation, hand off to `$numados-explain`. If the primary request is to find a defect, fix or implement something, search the repository, review a change, or answer from task history, let the corresponding specialist skill handle it instead.

A finished conclusion that must be written up for someone else stays here even when it has to be plain-language: the deliverable is a bounded report for a named reader, not a walk-through for the person asking. When another skill already produced the finding — a review, a verification, a task answer — take its verdict as given and shape the report around the reader's decision; do not reopen the investigation.

Before returning, verify that the reader can answer: what is this, why does it exist, what are its main parts, and what matters now. When the report carries a conclusion, they must also be able to answer what was concluded, what changes next, and what will stay broken. If a claim is uncertain, label it once rather than filling the gap with plausible detail.
