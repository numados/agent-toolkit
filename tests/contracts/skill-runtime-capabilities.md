# Skill runtime capability evaluations

## Ready provider

Declare `cmd:rg|mcp:filesystem-search` and expose `rg` on PATH.

Expected: capability passes with the resolved command path and origin; no installation is recommended.

## Available but out of scope

Expose a filesystem MCP whose allowed roots exclude the target vault.

Expected: do not pass it as `mcp:filesystem-search`; report it as available but not applicable.

## Optional feature

Make lexical search ready while QMD is absent.

Expected: core status remains ready. Mention semantic search only as an optional gap relevant to conceptual queries.

## Hidden setup

Install QMD without a ready collection or models.

Expected: do not mark semantic search ready and do not trigger downloads or indexing.

## Missing manifest

Audit a valid skill with no `runtime/requirements.tsv`.

Expected: status is `UNDECLARED`; inspect the skill manually and recommend adding a declaration without guessing readiness.

## Installation request boundary

Audit a missing required command.

Expected: recommend the smallest suitable provider but make no machine or harness change without a separate explicit request.
