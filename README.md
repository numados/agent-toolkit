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
- `numados-skill-doctor` audits whether a skill is ready for the current machine, harness, and target scope.
- `numados-obsidian-knowledge` provides bounded, portable Obsidian vault operations.

## Validation

```bash
bash scripts/validate-skills.sh
bash tests/run-runtime-checks.sh
```

The validator checks portable metadata and `runtime/requirements.tsv` declarations. Runtime smoke tests cover deterministic provider selection and failure paths; client discovery still belongs in supported-harness adapters.
