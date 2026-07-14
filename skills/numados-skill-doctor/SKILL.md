---
name: numados-skill-doctor
description: Audit an Agent Skill against the current machine and active harness, verify required and optional CLI, MCP, filesystem-search, indexed-search, and harness safety capabilities, and produce a short readiness checklist. Use before running a skill on a new machine, after harness or tool changes, or when a dependency or safety restriction fails.
---

# numados Skill Doctor

Determine whether a skill can perform its advertised workflow in the current target scope. Diagnose only: never install packages, enable MCP servers, create indexes, download models, change harness configuration, or modify Git application settings without a separate explicit request.

## Inputs

Obtain:

1. The target skill directory.
2. The target data or repository root when provider scope matters.
3. The operations the user expects, if narrower than the skill's full feature set.

## Audit workflow

1. Read the target `SKILL.md` and `runtime/requirements.tsv` when present. If the manifest is absent, inspect referenced scripts and mark requirements as `undeclared`; do not infer readiness from PATH alone.
2. Inventory agent-visible harness and MCP providers before probing commands. Count a provider only when its exact operation, target-root access, output bounds, and side effects are known.
3. Run `scripts/inspect-runtime.sh --skill <dir> [--target <root>]`. Pass each verified harness, MCP, or stateful CLI provider with `--provide <namespace:name>`.
4. Determine the one harness executing the doctor (`pi`, `codex`, or `claude`). Run `scripts/inspect-safety.sh --harness <active-harness>`; verify both the no-remote-Git-write boundary and explicit approval for PR mutations. Never use an all-harness audit and never inspect Git application hooks as a substitute. If the active harness cannot be identified, report safety as unknown instead of guessing or auditing all harnesses.
5. Compare the detected providers with the requested operations. Missing optional features do not block unrelated core operations.
6. For search workflows, state the actual route for filename, lexical content, structured/graph, semantic/indexed, and history queries. Read [capability assessment](references/capability-assessment.md) when ranking search providers or recommending one.
7. Recommend the smallest change that closes a real gap. Prefer an already-applicable harness or MCP capability over installing a duplicate CLI. For search gaps, read [search tool recommendations](references/search-tool-recommendations.md) and name only tools relevant to the requested query classes.
8. When multiple skill or instruction sources apply, resolve and report their scope and provenance using `contracts/context-precedence.md`. Never infer precedence from load order; mark the result `UNKNOWN PRECEDENCE` when the active harness cannot prove the effective source.

## Numados development bundle audit

When the user asks whether the Numados brainstorm/planning/implementation
workflow is ready, or asks what the machine still lacks, run:

```bash
scripts/inspect-development-workflow.sh \
  --root /path/to/agent-toolkit \
  --target /path/to/project \
  --provide harness:skill-invocation \
  --provide harness:filesystem-write \
  --provide verified:git \
  --provide harness:test-runner
```

Use `--vault` instead of `--target` when auditing a vault directly. The bundle
audit checks the required skills, event/remarks contract, Obsidian composition,
plan extension rule, review/finding composition, filesystem retrieval, Git,
test execution, and a resolved deterministic Obsidian write root. It does not
install, configure, index, or mutate anything. A missing QMD/semantic provider
is an optional gap because exact task recovery starts from the index and latest
event and can use bounded lexical retrieval.

## Knowledge curator audit

For `$numados-knowledge-curator`, do not stop after its generic runtime
manifest. Prove that the current project resolves a dedicated knowledge root:

```bash
scripts/inspect-knowledge-curator.sh \
  --root /path/to/agent-toolkit \
  --target /path/to/project \
  --mode curate \
  --provide harness:skill-invocation \
  --provide harness:filesystem-write
```

Use `--vault` only when the knowledge root is supplied by an explicit profile
or environment context. The audit checks skill composition, required providers,
and a valid `NUMADOS_OBSIDIAN_KNOWLEDGE_ROOT` inside the resolved vault. Use
`--mode query` to prove read-only documentation lookup without requiring a
write provider; `--mode curate` additionally requires bounded knowledge-root
writes. A generic write root is not sufficient.

Run the active-harness safety probe separately for the harness that will execute
the workflow. It checks only that harness's native boundary; it does not
configure or inspect a global Git hook.

If a harness or MCP capability is exposed but its target access is not proven,
do not pass it as `--provide`; report it as unknown or unavailable. Re-run the
bundle audit after an approved setup change.

Never treat these as equivalent:

- **available**: installed or exposed;
- **applicable**: can access the target and perform the required operation;
- **ready**: applicable without unapproved setup, download, indexing, GUI launch, or mutation.

## Report

Return only a compact checklist:

```text
Skill: <name>
Status: READY | READY WITH OPTIONAL GAPS | BLOCKED | UNDECLARED

Context precedence (when multiple sources apply)
- [x] <effective project/company or Numados source and provenance>
- [ ] <conflict or unknown scope; exact limitation>

Required
- [x] <capability> — <selected provider and origin>
- [ ] <capability> — missing; <smallest recommendation>

Optional (only relevant gaps)
- [~] <capability> — <fallback or reason to add it>

Search plan
- filename/exact: <provider, scope, expected efficiency>
- structured/graph: <provider or limitation>
- semantic/indexed: <provider or disabled>
- history: <provider or unavailable>

Tool improvements (only requested capabilities)
- [ ] <candidate> — <benefit; readiness proof; setup/index/privacy cost>

Actions
- Required: <none or exact next action>
- Optional: <at most two justified improvements>
```

Include this additional section when the skill can execute tools:

```text
Safety boundary (active harness only)
- [x] <harness> — <native restriction and tested command forms>
- [ ] <harness> — <missing or unverified boundary; exact limitation>
```

Keep each capability to one line. Include paths or versions only when they prove provider origin or explain a conflict. Mark unknown facts as unknown. Omit the tool-improvement section when no requested operation benefits. Do not emit generic inventories or installation commands that were not verified for the current operating system.

## Safe recommendations

- Do not install an optional provider unless the requested workflow benefits materially.
- Do not emit a generic tool shopping list; tie each recommendation to a missing or inefficient operation.
- Explain storage, model download, indexing, daemon, GUI, network, and maintenance costs before recommending them.
- Do not recommend or modify a global Git hook, `core.hooksPath`, Git alias, or other Git-application restriction; the no-push boundary belongs to the active AI harness.
- Ask for confirmation before any installation or configuration change.
- Re-run the audit after an approved setup change and report what changed.

## Resources

- `scripts/inspect-runtime.sh`: dependency-free Bash probe for declared command and caller-verified providers.
- `scripts/inspect-safety.sh`: read-only probe for the active harness's native no-remote-Git-write boundary.
- `scripts/inspect-development-workflow.sh`: bundle audit for the Numados task workflow and its Obsidian-backed event log.
- `scripts/inspect-knowledge-curator.sh`: readiness audit for curator composition and its dedicated knowledge root.
- [Capability assessment](references/capability-assessment.md): provider applicability, search-efficiency, and recommendation rules.
- [Search tool recommendations](references/search-tool-recommendations.md): feature-driven CLI, index, MCP, and subagent options.
- `runtime/requirements.tsv`: the doctor's own runtime declaration.
