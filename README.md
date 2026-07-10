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
└── scripts/validate-skills.sh
```

## First Skill

`skill-author` creates, updates, and reviews skills in this repository. Use it before adding another skill so that the same activation, safety, portability, and evaluation rules are applied consistently.

## Validation

```bash
bash scripts/validate-skills.sh
```

The script validates the portable metadata contract for every `skills/*/SKILL.md`. It does not prove client discovery or execution; those checks will be added per supported harness in `adapters/`.
