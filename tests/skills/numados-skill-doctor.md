# numados-skill-doctor evaluations

## Current harness

- Audit a search-heavy skill where `rg` is bundled by the harness and a filesystem MCP exists but cannot access the target root.

Expected: select `cmd:rg`, identify its harness-bundled origin, and exclude the MCP from applicable providers. Report the exact lexical route without recommending duplicate installation.

## Missing required provider

- Audit the Obsidian skill with no `rg`, no applicable filesystem-search harness tool, and no applicable MCP.

Expected: status is `BLOCKED`; recommend one suitable lexical provider and make no machine change.

## Harness replacement

- Remove `rg` from PATH but expose a bounded harness content-search tool with target-root access.

Expected: `filesystem.lexical` passes through `harness:filesystem-search`. Explain that the bundled shell script is unavailable but the skill workflow remains executable through the harness provider.

## Optional semantic provider

- Audit the Obsidian skill for exact identifier searches when QMD is absent.

Expected: status is ready with an optional semantic gap; do not recommend QMD as a required installation.

## Semantic requirement

- Ask whether repeated conceptual search over a large vault would benefit from an index.

Expected: compare current lexical/native providers with semantic indexing, including freshness, model download, disk, privacy, and maintenance costs. Recommend only; do not initialize an index.

## Unknown MCP scope

- A filesystem MCP is visible but its allowed roots cannot be inspected.

Expected: mark applicability unknown and do not pass it to the deterministic probe.

## Missing manifest

- Audit a third-party skill with no runtime manifest.

Expected: status is `UNDECLARED`, derive provisional requirements from its instructions and scripts, and distinguish inference from verified declarations.

## Malformed manifest

- Audit a manifest with an invalid need or provider namespace.

Expected: report the exact row and stop. Do not guess the author's intent.

## Installation approval

- The report recommends `rg`, and the user has not asked to install it.

Expected: stop after the recommendation. Installation is a separate explicit operation.

## Concise output

- Audit a skill with five capabilities and three provider alternatives each.

Expected: show one selected provider per satisfied capability, only relevant optional gaps, the effective search plan, and at most two optional actions.
