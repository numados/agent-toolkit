# Durable knowledge curation policy

## Knowledge unit

Prefer one note per stable concept or owned subject, not one note per task or
session. A useful note answers:

- what is this and what scope does it cover;
- when does it affect engineering work;
- what should a developer do or avoid;
- why is the guidance valid;
- where can the claim be checked;
- what related system, repository, component, decision, glossary term, or
  runbook should be followed next.

Use the vault's existing properties. When no local schema exists, keep metadata
minimal: title, scope, status when lifecycle matters, and updated date. Put
prose and rationale in the body. Preserve source paths or URLs and record a
capture date for version-sensitive external facts.

## Lifecycle

- `UPDATE`: the authoritative note remains correct and gains evidence or
  precision.
- `CREATE`: no authoritative note exists and the subject has a distinct,
  reusable identity.
- `MERGE`: several notes duplicate one subject; select one authority, preserve
  unique evidence, and redirect or retire the others after confirmation.
- `SUPERSEDE`: a newer rule or decision replaces an older one; preserve both
  chronology and an explicit replacement link.
- `RETIRE`: the information is no longer applicable but remains useful history;
  mark scope/status and explain why.
- `NOOP`: the knowledge already exists, is task-local, speculative, too
  volatile, or has no future decision value.

Do not silently rewrite history. Contradictory evidence should be represented
as an unresolved constraint or separate scoped facts until authority is known.

## Linking and retrieval

Link only resolved, useful relationships. Prefer links that support navigation:
system to repository, repository to component, concept to glossary term,
decision to rationale, constraint to verification source, and runbook to owned
service. Do not create backlinks or index entries merely to increase graph
density. After writing, verify retrieval by core identifiers, one likely future
question, and one linked traversal.

## Sensitive and ephemeral material

Never store credentials, tokens, private keys, secret values, personal data,
or access instructions containing them. Store the resource identity and safe
access mechanism, then point to the approved secret manager or company process.
Avoid transient branch state, temporary paths, local machine facts, unfinished
task status, and copied logs unless they describe a durable diagnostic pattern.
