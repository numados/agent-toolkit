---
name: numados-clear-report
description: Produce a concise structured orientation report—a map, not a tutorial—for supplied code, architecture, pull requests, logs, configuration, documents, or business requirements. Use when the user asks what something is, what it contains, how it fits, or wants a quick overview without extra explanation; do not use for step-by-step teaching, debugging, implementation, review, search, or task navigation.
---

# Numados Clear Report

Give the reader a fast, accurate orientation. This is a map of the material, not a tutorial. Reply in the conversation's language; preserve exact technical and business terms when precision matters, and translate them at first use.

## Ground the report

Read the supplied material before reporting it. For a code path, inspect the relevant source. For a PR, document, log, configuration, or requirement, use the supplied artifact and only the relevant surrounding context. If an essential source is inaccessible, ask for that source in one precise sentence instead of guessing.

Keep these states distinct:

- **Fact** — directly supported by the supplied source or authoritative documentation.
- **Conclusion** — a bounded conclusion derived from stated facts.
- **Unknown** — information that materially affects the report but is unavailable.

Never invent file contents, dependencies, business rules, metrics, or examples. Mark any hypothetical example explicitly.

## Output contract

Use only sections that contain useful information. Collapse empty sections. Default to roughly 150–200 words unless the material needs more to preserve its structure.

Render these headings in the conversation's language. The English labels below describe the required sections:

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

Start with the essence, not background. Prefer bullets over paragraphs. Use a table only for several exact mappings or a real comparison. Use a flow only when at least three components, branches, or state transitions are harder to follow in prose. Do not add analogies, a deep dive, exhaustive file lists, generic praise, or recommendations unless requested.

## Routing boundary

If the user says they do not understand, asks to unpack **how** or **why**, or asks for a step-by-step explanation, hand off to `$numados-explain`. If the primary request is to find a defect, fix or implement something, search the repository, review a change, or answer from task history, let the corresponding specialist skill handle it instead.

Before returning, verify that the reader can answer: what is this, why does it exist, what are its main parts, and what matters now. If a claim is uncertain, label it once rather than filling the gap with plausible detail.
