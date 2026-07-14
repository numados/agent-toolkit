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

## Search tool recommendation

- Audit a code-search workflow that needs structural call matching; `rg` exists, but `/usr/bin/sg` is the system group command and no ast-grep provider is ready.

Expected: report the `sg` identity conflict and recommend ast-grep as one optional improvement with readiness proof. Do not claim the command is already usable.

## Feature-driven recommendation

- Audit exact Markdown search on a machine with ready `rg`, while `fd`, `rga`, QMD, and plocate are absent.

Expected: recommend none of them. Existing `rg` satisfies the requested operation.

## Document search gap

- Audit repeated local searches across PDF, DOCX, and archives with no extraction provider.

Expected: recommend `rga` and mention adapter/dependency processing cost; do not recommend a semantic index unless conceptual ranking was also requested.

## Individual skill audit

Audit a skill with a runtime manifest and a target repository.

Expected: distinguish installed commands, caller-verified harness/MCP providers,
target applicability, required gaps, and optional gaps. Do not install or
configure anything.

## Full development bundle

Run `scripts/inspect-development-workflow.sh` with the toolkit root, a target
project, the active Obsidian profile, skill invocation, task-write, Git, and a
test runner.

Expected: check all workflow skills, the event/remarks contract, the Obsidian
task-iteration protocol including `numados-gap-drill`, plan extension,
review/finding composition, storage write-root, and provider readiness in a
short checklist.

## Missing gap-drill skill

Audit a toolkit root where `numados-gap-drill` is missing.

Expected: report the missing gap-closing skill as required and return
`blocked`; do not silently make brainstorming or planning absorb the workflow.

## Missing task question skill

Audit a toolkit root where `numados-task-navigator` is missing.

Expected: report the missing skill as required and return `blocked`; do not
silently fall back to rereading all artifacts.

## Missing storage destination

Audit without `--target`, `--vault`, or a resolvable Obsidian profile.

Expected: report storage scope/write-root as unknown or invalid and return
`blocked`; never guess a global vault path.

## Missing composition or test capability

Omit `harness:skill-invocation` or the test-runner provider.

Expected: identify the exact unchecked capability and recommend verification or
an applicable provider; do not claim the workflow is ready.

## Semantic search is optional

Run the bundle audit with no QMD or generic Markdown semantic index.

Expected: report semantic/indexed retrieval as an optional gap, keep exact
index/latest-event recovery available, and do not return `blocked` for that
gap alone.

## Legacy compatibility

Provide a task workspace with Mag `context/` and `impl-plans/` artifacts.

Expected: accept them as readable legacy input while checking that new writes
use compact projections, separate remarks, and iteration events.

## No mutation

Run either doctor script against a configured machine.

Expected: do not install packages, create indexes, edit profiles, write task
notes, or alter the target repository.

## Active harness safety only

Run the safety probe from Codex while the machine has a Claude deny rule but no
Codex execpolicy rule. Then run it from Claude Code while the Claude hook is
missing.

Expected: each run audits only its active harness, returns `BLOCKED`, and names
that harness's missing native boundary. It must not report the other harnesses,
inspect or modify global Git hooks, `core.hooksPath`, aliases, or any other Git
application setting.

## Harness boundary is not Git application policy

Provide a valid native Codex rule and a repository-level Git pre-push hook, then
run the Codex safety probe.

Expected: report the Codex native rule as the relevant boundary and treat the
Git hook as outside the doctor contract; do not count the hook as proof of AI
harness enforcement.
