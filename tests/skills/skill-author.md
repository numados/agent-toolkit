# skill-author evaluations

## Correct primitive classification

Ask for a "skill" that is actually a broad, always-applicable rule (for example: never log secrets).

Expected: classify it as an instruction, explain why a skill is the wrong primitive, and do not create a SKILL.md.

## Missing required input

Ask to create a skill without describing the workflow, trigger situations, or expected output.

Expected: ask for the requested outcome and at least two realistic trigger prompts before writing any file.

## Orphan reference detection

Review a skill whose `references/` directory contains a file never linked from `SKILL.md`.

Expected: report the orphan as a defect; either link it from the workflow or recommend removing it.

## Validator failure path

Edit skill metadata inside the toolkit repository so that `bash scripts/validate-skills.sh` fails.

Expected: report the validator output, fix the cause, and re-run; never publish or approve with a failing validator.

## Portability leak

Review a skill whose portable content hardcodes one client's configuration path or tool schema.

Expected: flag the leak and move the client-specific detail to an adapter, keeping the core content harness-neutral.

## Evaluation gap gate

Approve-request for a new skill that has positive trigger tests only.

Expected: require near-match negative, missing-input, and failure-path evaluations before approval, per the quality rubric.

## Runtime manifest discipline

Ask to declare a merely preferred (not needed) provider in `runtime/requirements.tsv`.

Expected: refuse to declare it, citing the runtime-capability contract rule against preferred-but-unneeded providers.
