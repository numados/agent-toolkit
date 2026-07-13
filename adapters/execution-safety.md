# Execution-safety adapter guide

The portable policy is [`../contracts/execution-safety.md`](../contracts/execution-safety.md).
This file defines how to distribute it without copying a large, drifting rule
set into every harness.

## Distribution model

Use one versioned contract and two small projections per harness:

1. **Instruction projection** — a concise block in the harness's global or
   project instructions. It tells every agent what is prohibited and when to
   stop.
2. **Enforcement projection** — the harness-native deny, approval, hook,
   sandbox, or wrapper mechanism that acts before the command/tool executes.

The instruction projection is portable context, not a security boundary. The
enforcement projection must be tested independently and record the contract
version it implements. Do not make a copied `AGENTS.md` or `CLAUDE.md` the
canonical policy; update the contract first and regenerate or update the
projections deliberately.

Machine-local files such as `~/.ai-config`, `~/.codex`, `~/.claude`, and
`~/.pi/agent` are deployment targets. They must not become an undocumented
second source of truth.

## Harness mapping

| Harness | Instruction surface | Enforcement surface | Important limitation |
| --- | --- | --- | --- |
| Claude Code | `CLAUDE.md` or shared `AGENTS.md` projection | `permissions.deny`, `ask`, and a `PreToolUse` hook; managed settings when the rule must not be overridden | A broad allowlist or bypass mode must not weaken the hard deny. Test compound commands and wrappers. |
| Codex CLI | global/project `AGENTS.md` projection | `workspace-write` or narrower sandbox plus approval policy and `execpolicy` rules | `approval_policy = "never"` and `--yolo` remove approval as a control. `AGENTS.md` alone cannot block a command. |
| Pi | global agent/skill projection and child-agent prompt | `tool_call` extension that returns `{ block: true }`; child harnesses need their own guard | A parent Pi extension does not automatically intercept commands spawned by Codex, Claude, or AGY. |
| Auggie or another CLI | its supported instruction file | native command policy if available; otherwise a wrapper/OS boundary and defense-in-depth Git hook | If no pre-execution enforcement exists, report instruction-only protection rather than claiming a hard block. |

## Deployment rules

- Keep the hard no-push rule in every adapter, even when a provider supports
  remote reads or the user commonly asks for remote reviews.
- Keep provider-specific command names in the adapter, not in the portable
  contract. The contract describes remote mutation semantics; an adapter maps
  them to `gh`, `az`, `glab`, MCP tools, or another installed provider.
- Do not enable full-access, bypass, or YOLO modes on the host when the policy
  depends on approvals. If such a mode is required for an isolated sandbox,
  keep a boundary guard outside the model's control.
- Pass the same safety projection to every delegated agent. A coordinator's
  local rule does not protect a child process that has its own shell.
- Do not use a global Git hook, `core.hooksPath`, Git alias, or repository hook
  as the AI boundary. Existing project hooks may remain independent safeguards,
  but the active harness must enforce its own rule before invoking Git.
- Prefer a short generated projection over manually duplicating the full
  contract. Future adapter tooling should accept the contract path and emit
  native configuration plus negative tests; generated files remain deployment
  artifacts, not new policy sources.

## Minimum adapter test matrix

For each harness, assert that the enforcement layer:

1. blocks `git push` without asking;
2. blocks a refspec and force-push form;
3. blocks a compound command containing a push;
4. allows bounded read-only Git inspection;
5. asks before local destructive or remote-mutating operations;
6. preserves the rule for delegated agents where delegation is supported.

If a test cannot be implemented for a harness, document the gap and use a
stronger outer boundary instead of weakening the portable contract.
