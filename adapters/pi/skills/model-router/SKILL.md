---
name: model-router
description: Route Pi work to the cheapest model that preserves correctness by separating evidence collection, ordinary execution, complex reasoning, planning, review, and external Codex or Claude calls. Use for every Pi task that may be delegated or needs model selection.
---

# Pi model routing

Classify the operation before delegating. Keep collection separate from
decisions: a cheap agent may retrieve and compress evidence, but must not make
an architectural, review, security, or irreversible decision from weak
evidence.

## Routing table

| Work | Route | Effort |
|---|---|---|
| Read task text, fetch supplied documents, locate files, extract facts | `scout` | DeepSeek V4 Flash, `low` |
| Small deterministic edit with a clear plan | `worker` | DeepSeek V4 Flash, `low` |
| Ambiguous or cross-cutting routing decision | Pi orchestrator | GLM 5.2, `xhigh` |
| Planned multi-file implementation | `worker-glm` | GLM 5.2, `high` |
| Planning or code review | `planner` or `reviewer` | GLM 5.2, `xhigh` |
| Lightweight Codex lookup or extraction | `codex_call(complexity=light)` | `gpt-5.6-luna`, `max` |
| Deep Codex analysis, debugging, or implementation | `codex_call(complexity=complex)` | `gpt-5.6-sol`, `high` |
| BTCS Claude reasoning | `claude_call(agent=claude-btcs, effort=high)` | Opus 4.8 1M, `high` |
| BTCS Claude routine reading or summarization | `claude_call(agent=claude-btcs, effort=low)` | Opus 4.8 1M, `low` |
| Fixed AGY lookup | `agy_call` | Gemini 3.5 Flash (High) |

## Rules

1. Use `low` or `minimal` for bounded extraction, not for deciding whether a
   finding is real or whether a change is safe.
2. Keep collection agents read-only and require bounded output: paths,
   claims, evidence locations, uncertainty, and a short next-step suggestion.
3. Escalate when terminology is ambiguous, evidence conflicts, the task writes
   code, or correctness depends on several interacting components.
4. Do not silently downgrade a planner or reviewer to a cheap model.
5. Pass the smallest useful context to a delegated agent. Do not preload full
   skills when a short task-local contract is enough.
6. When an external call fails, report the failure and use the configured GLM
   route only when the task remains safe to continue.

The actual model identifiers belong to this Pi adapter, not to portable
Numados skills.
