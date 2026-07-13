# Agent Toolkit

Version-controlled agent context for use across machines and compatible AI coding harnesses.

## Purpose

This repository will hold four distinct kinds of context:

- `skills/`: reusable, on-demand workflows;
- `memory/`: portable baseline knowledge that is useful across repositories;
- `contracts/`: durable behavioural and integration agreements;
- `adapters/` and `mcp/`: client-specific configuration and non-secret integration definitions.

The portable core stays independent of a particular client. Harness-specific paths, metadata, plugins, and MCP schemas belong in adapters.

## Initial Structure

```text
.
├── AGENTS.md
├── skills/
│   └── skill-author/         first reusable workflow
├── memory/                   curated shared knowledge
├── contracts/                versioned agreements
├── adapters/                 harness-specific renderers and tests
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

## Validation

```bash
bash scripts/validate-skills.sh
bash tests/run-runtime-checks.sh
```

The validator checks portable metadata, bundled-resource links, UI prompts, evaluation-file presence, and `runtime/requirements.tsv` declarations. Runtime smoke tests cover deterministic provider selection and failure paths; client discovery still belongs in supported-harness adapters.
