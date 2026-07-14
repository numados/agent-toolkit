# Agent Toolkit

Version-controlled agent context for use across machines and compatible AI coding harnesses.

## Purpose

This repository will hold four distinct kinds of context:

- `skills/`: reusable, on-demand workflows;
- `memory/`: portable baseline knowledge that is useful across repositories;
- `contracts/`: durable behavioural and integration agreements;
- `adapters/` and `mcp/`: integration boundaries and non-secret definitions;
  substantial harness-specific implementations live in their own repositories.

Execution boundaries are defined by [`contracts/execution-safety.md`](contracts/execution-safety.md)
and projected into each harness through [`adapters/execution-safety.md`](adapters/execution-safety.md).
Skill and instruction conflicts follow [`contracts/context-precedence.md`](contracts/context-precedence.md): project/company context takes precedence over Numados base context, with adapter-visible provenance.

The portable core stays independent of a particular client. Harness-specific paths, metadata, plugins, and MCP schemas belong in adapters.

The Pi-specific runtime is maintained in the separate `pi-agent-toolkit`
repository. It defines model and effort routing, target-specific agent
manifests, external-tool contracts, and the non-destructive Pi installer.

## Initial Structure

```text
.
├── AGENTS.md
├── skills/
│   └── skill-author/         first reusable workflow
├── memory/                   curated shared knowledge
├── contracts/                versioned agreements
├── adapters/                 integration boundaries and shared adapter notes
├── mcp/                      non-secret MCP definitions
├── scripts/validate-skills.sh
└── tests/run-runtime-checks.sh
```

## Core Skills

- `skill-author` creates, updates, and reviews reusable skills.
- `numados-code-review` reviews pull requests and diffs, validates candidates, and reports only actionable findings.
- `numados-verify-finding` validates review findings before they become PR comments.
- `numados-commit-message` generates repository-aligned commit messages without committing.
- `numados-csharp` guides C# implementation that follows repository conventions.
- `numados-rust` guides Rust implementation that follows repository conventions.
- `numados-explain` turns technical material into concise explanations designed for first-read understanding.
- `numados-skill-doctor` audits whether a skill is ready for the current machine, harness, and target scope.
- `numados-local-search` routes local retrieval to bounded lexical, structural, semantic, document, indexed, or history providers.
- `numados-obsidian-knowledge` provides bounded, portable Obsidian vault operations.
- `numados-brainstorm` researches a task and records evidence-grounded context before planning.
- `numados-gap-drill` closes decision-relevant gaps with bounded evidence and a minimal user decision loop.
- `numados-planning` turns approved context into repository-aligned phases and verification criteria.
- `numados-implementation` executes approved phases, records iteration events, and closes the verified review loop.
- `numados-task-navigator` answers questions about an active or completed task from its current state and linked evidence.
- `numados-harness-setup` discovers the active harness, previews setup changes, applies them only after confirmation, and verifies or rolls back native installation state.

## Development workflow

The workflow skills share [`contracts/development-workflow-artifacts.md`](contracts/development-workflow-artifacts.md) and use `$numados-obsidian-knowledge` for durable storage. A task workspace keeps compact current projections in `_task_index.md`, `research.md`, and `plan.md`; review remarks are separate in `remarks.md` when needed; meaningful transitions are immutable notes under `iterations/`. Existing Mag `context/` and `impl-plans/` artifacts remain readable as legacy input but are not created by default.

The normal handoff is:

```text
numados-brainstorm -> numados-gap-drill (when gaps remain) -> user decision gate -> numados-planning
       -> numados-gap-drill (when plan gaps remain) -> user approval gate -> numados-implementation
       \
        -> numados-task-navigator (questions at any stage)
```

The implementation skill delegates final code review to `numados-code-review`, which validates candidates through `numados-verify-finding`. It does not assume a specific forge, ticket tracker, or branch convention; task state is routed through the configured Obsidian skill.

`numados-skill-doctor` checks the safety boundary only for the harness that is
currently executing it. The native boundary is an AI-harness concern; the
toolkit does not install or modify global Git hooks, aliases, or `core.hooksPath`.

## Validation

```bash
bash scripts/validate-skills.sh
bash tests/run-runtime-checks.sh
```

The validator checks portable metadata, bundled-resource links, UI prompts, evaluation-file presence, and `runtime/requirements.tsv` declarations. Runtime smoke tests cover deterministic provider selection and failure paths; client discovery still belongs in supported-harness adapters.
