# Pi adapter

Target-specific model and agent configuration for Pi `0.80.3` with
`@tintinweb/pi-subagents` `0.13.0`.

The portable skills remain model-agnostic. This adapter maps workload roles to
models, thinking effort, tool boundaries, and external Pi extensions.

## Routing policy

- Read-only collection and extraction: DeepSeek V4 Flash with `low` thinking.
- Ordinary Pi orchestration: the configured GLM 5.2 model with `xhigh` thinking.
- Planning and review: GLM 5.2 with `xhigh` thinking.
- AGY: keep the fixed Gemini 3.5 Flash (High) model.
- Claude BTCS: Opus 4.8 1M with `low` for routine work and `high` for reasoning.
- Codex light: `gpt-5.6-luna` with `max` reasoning.
- Codex complex: `gpt-5.6-sol` with `high` reasoning.

The Pi defaults are in [settings.overlay.json](settings.overlay.json); the
exact role mapping is in [model-routing.json](model-routing.json). Invocation
details for external tools are in [external-tools.md](external-tools.md). Pi exposes
`xhigh` but not `max` as a subagent thinking level; `max` is therefore only
used for the Codex CLI integration.

## Apply

From the repository root:

```bash
adapters/pi/apply-model-routing.sh
```

Set `PI_CODING_AGENT_DIR` to target another Pi installation. The script merges
only the adapter-owned defaults, installs the adapter-owned agents and router
skill, preserves unrelated files, and creates a timestamped backup before
overwriting an existing managed file. Use `--dry-run` to inspect the target.

The script does not install packages, change MCP servers, or expose credentials.
