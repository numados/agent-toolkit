# Codex Instructions

These instructions supplement the shared global instructions only in the Codex harness. Project and company instructions take precedence.

## Cost-Aware Fan-Out (Codex)

**Applicability:** Apply this entire section only when the active harness is Codex. Claude Code, Pi, agy, and all other harnesses must ignore this section and retain their own delegation and model-selection rules. Determine the harness from the active runtime, not from the model provider, repository name, or presence of this shared file. If the harness cannot be identified, do not apply this section.

- When fan-out is requested or delegation is authorized by applicable instructions, choose each subagent's model and reasoning effort explicitly by task complexity. This authorizes model overrides; it does not require delegation for every task.
- Default routing: bounded file search and fact extraction → Luna with `xhigh`; implementation → Astra with `low`; review, analysis, and verification → Astra with `medium`. Keep final synthesis and validation with the parent.
- Use the latest available version within each assigned model family, not a pinned historical version. Resolve an exact model ID from the active spawn tool or runtime model catalog at execution time; use only exposed models and supported effort levels. Never invent a `latest` alias or select by version-number sorting alone. If release order is unclear, verify official documentation. Disclose unavailable families and any fallback; do not silently switch task tiers.
- Prefer `fork_turns="none"` where supported. Give each agent a self-contained brief with the goal, constraints, relevant paths, known facts, and expected output. Let the agent request missing context from the parent. Do not copy the entire conversation by default; full-history forks may prevent model overrides.
- Require concise results with evidence (`path:line` for code), conclusions, and unresolved uncertainty. If the task exceeds the agent's capability, return the evidence and blocker to the parent, which decides whether to use a stronger model.
- Delegate independent, substantial tasks. Run a single bounded search directly, avoid overlapping assignments, and keep final validation and synthesis with the parent.
- Before spawning, show a short task → model → reasoning mapping. Treat these settings as requested until runtime evidence confirms them; do not claim measured savings without usage evidence.
