---
name: numados-explain
description: Explain supplied code, architecture, business requirements, errors, decisions, or changes step by step in plain language when the user explicitly invokes $numados-explain or says they do not understand, asks to unpack how or why, or requests a walk-through. Ground the explanation in evidence and adapt its depth; do not use it for implementation, diagnosis, review, repository search, or task navigation as the primary request.
---

# Numados Explain

Explain the material accurately and accessibly, in the order the reader needs to understand it. Optimize for progressive comprehension, not maximum length: start with the minimum useful model and expand only where a reasoning jump would otherwise remain.

## Ground the explanation

Read the supplied material before explaining it. For a path or repository, inspect the relevant source. For a remote URL, infer its provider from the host/path and use an already available read-only provider. For a general topic whose current behavior matters, consult authoritative sources.

If the source cannot be accessed and its contents are essential, ask for that source in one precise sentence. Otherwise infer the reader's baseline from the conversation and proceed without an interview.

Separate:

- `Fact`: directly supported by source, code, behavior, or authoritative documentation.
- `Inference`: conclusion derived from stated evidence.
- `Unknown`: information that would materially change the explanation but is unavailable.

Never use invented “real-looking” data. Label a synthetic example as hypothetical.

## Reader baseline: assume a newcomer when context is unclear

Unless the user explicitly demonstrates service/domain knowledge, explain as if they are new to the service
and unfamiliar with the codebase. Do not make them infer what a `Trade`, `Booking`, handler, consumer, poller,
repository, or external system means.

Before discussing a bug or code change, establish the smallest service model needed to understand it:

1. **Service purpose:** what business process the service participates in.
2. **Actors and boundaries:** which component receives data, which component changes state, and which external
   system responds.
3. **Term glossary:** define each domain or code term at first use in one short sentence.
4. **State model:** show only the relevant states and transitions.
5. **Then explain the change or problem.**

Prefer a small ASCII flow when three or more components or state transitions interact:

```text
External system → service component → database/state → external response
```

Do not start with filenames or line numbers. Introduce implementation details only after the reader knows
what the component does and why it exists.

## Choose the shortest useful shape

Adapt to the material instead of forcing one template:

| Material | Explain in this order |
|---|---|
| Concept or architecture | what it is → why it exists → mental model → components and boundaries → example |
| Code or PR change | outcome → before/after behavior → entry point → execution flow → reason and impact |
| Business requirement | business goal → actor and trigger → scenario → rules and exceptions → acceptance criteria → edge cases and open questions |
| Bug or review finding | context → expected behavior → actual behavior → minimal failure scenario → root cause → impact → fix direction → evidence |
| Error message | immediate meaning → likely source → discriminating evidence → next action |
| Comparison or decision | decision first → material differences → trade-offs → recommendation |

Omit any stage that does not improve understanding.

## First-read structure

1. Start with a one-to-three-sentence **Conclusion** in the conversation's language. Say what changed or what is wrong before background.
2. Add **Context** when the reader may be new: service purpose, actors, and one small architecture flow.
3. Add **Terms** only for concepts needed in the explanation. Use exact identifiers in backticks and define them plainly.
4. Build one causal chain in execution order. For every step name: **actor → action → state change → consequence**.
5. For a bug or review finding, use this fixed structure:
   - **Expected:** what the system should guarantee.
   - **Actual:** what the code currently does.
   - **Failure scenario:** one minimal, explicitly hypothetical interleaving or input.
   - **Why it matters:** observable business or operational impact.
   - **Fix direction:** what needs to change, without implementing unless asked.
6. Add exact paths/lines only after the behavior is understandable; use them as evidence, not as the explanation.
7. End with **What to remember** — one sentence answering why this matters. If uncertainty remains, name the
   missing fact and how to verify it. If the user says they do not understand, explain one numbered step at a
   time and invite them to name the remaining term or step.

For an explicit "I do not understand" or "explain it slowly" request, use numbered steps with one idea per step. Do not expose hidden chain-of-thought; present only the concise, source-grounded reasoning needed to make the causal chain understandable.

Use active voice and short paragraphs. Prefer familiar concepts before new ones. Preserve exact technical terms where precision matters, but translate them immediately.

## Visual and token discipline

- Use a table only for several exact mappings or a real comparison.
- Use a flow or diagram when at least three interacting components, branches, or state transitions are easier to understand visually. For a bug, prefer one small causal flow over a large architecture diagram.
- Use code only for the smallest fragment that proves the explanation.
- Do not add decorative emoji, generic introductions, exhaustive file lists, or a “deep dive” the user did not request.
- Default to the shortest answer that preserves the full causal chain. Expand only at the exact point where compression would create a reasoning jump.

## Required visual structure for bugs and review findings

When explaining a bug, review finding, or race condition to a newcomer, use these headings unless the answer is
truly one sentence:

```text
## Conclusion
## Context: what this service does
## Terms
## Expected behavior
## What happens now
## Minimal failure scenario
## Why this matters
## What should change
## Evidence
## What to remember
```

Keep the scenario minimal and label it **hypothetical** when it is an interleaving rather than an observed
production incident. Explicitly say whether the issue is confirmed, possible, pre-existing, or unknown.

## Comprehension check

Before returning, verify that the reader can answer, where relevant:

- What happened or what is this?
- Why does it work this way?
- How does control or data move?
- What changed, breaks, or matters to me?

Remove repetition and background that does not help answer those questions. If uncertainty remains, name it once and state what evidence would resolve it.

## Routing boundary

Use `$numados-clear-report` when the user only wants a quick orientation such as what something is, what it contains, or how it fits. Do not turn a request to implement, diagnose, review, search, or navigate task history into an explanation; hand it to the corresponding specialist workflow. If both skills could apply, explicit lack of understanding or a request for how/why takes precedence over a report.
