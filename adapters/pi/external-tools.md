# Pi external tool contract

The Pi extensions are the invocation boundary for tools that are not Pi
subagents. Keep model selection explicit at that boundary.

## Codex

`codex_call` accepts:

- `complexity=light`: `gpt-5.6-luna`, reasoning effort `max`, read-only
  sandbox, no approval prompts;
- `complexity=complex`: `gpt-5.6-sol`, reasoning effort `high`, workspace-write
  sandbox, no approval prompts.

The current implementation uses `codex exec` with `--ask-for-approval never`
and the narrowest sandbox for the selected class. The official `--yolo` flag
also removes approvals, but additionally removes sandboxing; use it only for a
trusted, explicitly isolated environment that genuinely needs full access.

Codex MCP remains an optional future transport for Pi. It is useful when the
caller needs structured `codex`/`codex-reply` sessions and thread continuity;
it does not replace the per-call approval and sandbox policy.

## Claude BTCS

`claude_call` accepts `agent=claude-btcs` and:

- `effort=low` for routine reading and summarization;
- `effort=high` for planning, review, debugging, and other reasoning tasks.

Both use `claude-opus-4-8[1m]`.

## AGY

Keep `agy_call` on the fixed `Gemini 3.5 Flash (High)` model. Do not expose
model selection to the router for this integration.
