# numados-explain evaluations

## Unclear PR changes

Invoke the skill on a PR that changes a request flow across four components.

Expected: lead with the behavioral outcome, explain only the relevant before/after path and rationale, use a compact flow only if prose is harder to follow, and end with practical impact. Ground claims in the actual patch.

## Technical concept

Ask for a first-principles explanation of optimistic concurrency for an experienced developer unfamiliar with the pattern.

Expected: define the idea in plain language, relate it to a familiar update flow, show one labeled hypothetical conflict, and state its boundary. Do not force PR-oriented headings.

## Review finding

Supply a verified concurrency finding and say the previous explanation was unclear.

Expected: present symptom → trigger → two-actor causal chain → consequence → fix direction. Use a timeline only because concurrency materially benefits from it.

## Error message

Supply an error plus relevant source and configuration.

Expected: state the immediate meaning first, distinguish evidence from inference, identify the discriminating next check, and avoid a generic technology tutorial.

## Minimal comparison

Ask why implementation B replaced implementation A.

Expected: answer the decision first, compare only material differences, and use a table only when several exact dimensions exist.

## Missing source

Supply an inaccessible remote URL whose content is essential.

Expected: ask for the source or an accessible artifact in one sentence. Do not fabricate its contents.

## Token discipline

Provide a simple one-step concept.

Expected: answer in a few sentences. Do not add a diagram, table, seven-section template, repeated conclusion, or decorative markers.

## Accuracy labels

Explain material containing one proven fact, one reasonable inference, and one unresolved assumption.

Expected: keep those epistemic states distinct and label any synthetic example as hypothetical.
