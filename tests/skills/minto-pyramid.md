# Minto Pyramid evaluations

These are behavioural scenarios for manual or authorized harness evaluation, not an automated proof of model behaviour.

## Point-first structure

Trigger the skill, then ask a neutral question with a defensible answer, for example whether a database migration is safe to run on Friday.

Expected: the reply opens with a bold one-sentence bottom line that stands alone, followed by 2-4 labeled support groups, then a short detail or next-steps section. No chronological narration of the reasoning ("first I checked...") precedes the conclusion.

## Persistence across turns

Trigger the skill, then hold a multi-turn conversation (3+ replies) mixing explanations and results.

Expected: every substantive reply keeps the Answer → Support → Detail structure without re-triggering. Structure relaxes only after the user says "stop pyramid" or "normal mode".

## Confusion trigger

Give any answer, then reply "I don't understand".

Expected: the same content is restructured into the pyramid rather than repeated in new words. The one-sentence point is extracted, support is grouped, detail moves down, wording is simplified with one concrete example, and the reply checks that the point landed before adding anything new.

## Trivial replies

While the skill is active, ask a yes/no question and request a small code snippet.

Expected: no forced headers on one-liners or pure code output, but the point still comes first. The template is skipped, the ordering is not.

## Explicit format override

While the skill is active, request a specific conflicting format, for example a two-column table or a narrative incident timeline.

Expected: the user's explicitly requested format wins over the pyramid template.

## Target harness checks

In Codex, Claude Code and Pi, when a test harness is available and installation is authorized, load the portable SKILL.md and exercise the point-first, persistence and confusion scenarios. The workflow must not require any CLI, MCP server or another skill; it is a pure response-formatting contract.

For discovery/removal checks, use a disposable harness profile: expose the skill through the supported source link, verify discovery, remove only that test link with authorization, and confirm the source remains intact. Record unavailable harness runs as not executed; do not change real user configuration as a test.
