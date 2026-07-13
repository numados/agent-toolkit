---
name: numados-skill-doctor
description: Audit an Agent Skill against the current machine and harness, verify required and optional CLI, MCP, filesystem-search, and indexed-search capabilities, and produce a short readiness checklist with installation or configuration recommendations. Use before running a skill on a new machine, after harness or tool changes, when a dependency fails, or when comparing available search providers.
---

# numados Skill Doctor

Determine whether a skill can perform its advertised workflow in the current target scope. Diagnose only: never install packages, enable MCP servers, create indexes, download models, or change configuration without a separate explicit request.

## Inputs

Obtain:

1. The target skill directory.
2. The target data or repository root when provider scope matters.
3. The operations the user expects, if narrower than the skill's full feature set.

## Audit workflow

1. Read the target `SKILL.md` and `runtime/requirements.tsv` when present. If the manifest is absent, inspect referenced scripts and mark requirements as `undeclared`; do not infer readiness from PATH alone.
2. Inventory agent-visible harness and MCP providers before probing commands. Count a provider only when its exact operation, target-root access, output bounds, and side effects are known.
3. Run `scripts/inspect-runtime.sh --skill <dir> [--target <root>]`. Pass each verified harness, MCP, or stateful CLI provider with `--provide <namespace:name>`.
4. Compare the detected providers with the requested operations. Missing optional features do not block unrelated core operations.
5. For search workflows, state the actual route for filename, lexical content, structured/graph, semantic/indexed, and history queries. Read [capability assessment](references/capability-assessment.md) when ranking search providers or recommending one.
6. Recommend the smallest change that closes a real gap. Prefer an already-applicable harness or MCP capability over installing a duplicate CLI.

Never treat these as equivalent:

- **available**: installed or exposed;
- **applicable**: can access the target and perform the required operation;
- **ready**: applicable without unapproved setup, download, indexing, GUI launch, or mutation.

## Report

Return only a compact checklist:

```text
Skill: <name>
Status: READY | READY WITH OPTIONAL GAPS | BLOCKED | UNDECLARED

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

Actions
- Required: <none or exact next action>
- Optional: <at most two justified improvements>
```

Keep each capability to one line. Include paths or versions only when they prove provider origin or explain a conflict. Mark unknown facts as unknown. Do not emit generic inventories or installation commands that were not verified for the current operating system.

## Safe recommendations

- Do not install an optional provider unless the requested workflow benefits materially.
- Explain storage, model download, indexing, daemon, GUI, network, and maintenance costs before recommending them.
- Ask for confirmation before any installation or configuration change.
- Re-run the audit after an approved setup change and report what changed.

## Resources

- `scripts/inspect-runtime.sh`: dependency-free Bash probe for declared command and caller-verified providers.
- [Capability assessment](references/capability-assessment.md): provider applicability, search-efficiency, and recommendation rules.
- `runtime/requirements.tsv`: the doctor's own runtime declaration.
