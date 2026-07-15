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

## Choose the shortest useful shape

Adapt to the material instead of forcing one template:

| Material | Explain in this order |
|---|---|
| Concept or architecture | what it is → why it exists → mental model → components and boundaries → example |
| Code or PR change | outcome → before/after behavior → entry point → execution flow → reason and impact |
| Business requirement | business goal → actor and trigger → scenario → rules and exceptions → acceptance criteria → edge cases and open questions |
| Bug or review finding | symptom → triggering conditions → root cause → evidence → fix or decision |
| Error message | immediate meaning → likely source → discriminating evidence → next action |
| Comparison or decision | decision first → material differences → trade-offs → recommendation |

Omit any stage that does not improve understanding.

## First-read structure

1. Start with a one-to-three-sentence essence of the answer, in the conversation's language. State the conclusion before background.
2. Build one causal chain in execution order. For each step, name the actor, action, state change, and consequence; do not make the reader infer missing links.
3. Introduce each necessary term once, in plain language, at first use. Preserve exact identifiers, domain terms, and requirement language where precision matters.
4. Use one concrete example only when it removes abstraction. Keep values minimal and clearly sourced or hypothetical.
5. End with the practical consequence, decision, or one thing the reader should retain. If the user explicitly said it is unclear, invite them to name the step or term that remains unclear instead of repeating the whole answer.

For an explicit "I do not understand" or "explain it slowly" request, use numbered steps with one idea per step. Do not expose hidden chain-of-thought; present only the concise, source-grounded reasoning needed to make the causal chain understandable.

Use active voice and short paragraphs. Prefer familiar concepts before new ones. Preserve exact technical terms where precision matters, but translate them immediately.

## Visual and token discipline

- Use a table only for several exact mappings or a real comparison.
- Use a flow or diagram only when at least three interacting components, branches, or state transitions are harder to understand in prose.
- Use code only for the smallest fragment that proves the explanation.
- Do not add decorative emoji, generic introductions, exhaustive file lists, or a “deep dive” the user did not request.
- Default to the shortest answer that preserves the full causal chain. Expand only at the exact point where compression would create a reasoning jump.

## Comprehension check

Before returning, verify that the reader can answer, where relevant:

- What happened or what is this?
- Why does it work this way?
- How does control or data move?
- What changed, breaks, or matters to me?

Remove repetition and background that does not help answer those questions. If uncertainty remains, name it once and state what evidence would resolve it.

## Routing boundary

Use `$numados-clear-report` when the user only wants a quick orientation such as what something is, what it contains, or how it fits. Do not turn a request to implement, diagnose, review, search, or navigate task history into an explanation; hand it to the corresponding specialist workflow. If both skills could apply, explicit lack of understanding or a request for how/why takes precedence over a report.
