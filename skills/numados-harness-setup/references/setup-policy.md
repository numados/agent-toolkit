# Setup policy

## Discovery and questions

Use the active harness's own status, doctor, config inspection, and skill-list
commands when available. Then inspect only identified files. A command being on
`PATH` does not prove that it is the active harness or that it reads a target
root. If two plausible roots remain, ask which scope should be changed and
show both paths. Ask whether the target is current project, user-wide, or
managed/organization scope when that choice is not explicit.

The setup skill may learn a path from the harness or user, but must not create
a second unofficial discovery convention. Preserve the harness's native
precedence model and report when the requested corporate-over-base policy
requires a managed/enterprise surface that is unavailable.

## Adapter contract

The adapter must expose discovery, preview, apply, verify, and rollback for the
target harness. It owns native syntax and must preserve unmanaged fields.
Generic skill installers are allowed only for skill payloads; they are not
configuration adapters. An unavailable adapter is a hard `BLOCKED` result.

## Skill deployment layout

Toolkit skills are deployed as **symlinks from the harness skills directory to
the toolkit checkout** — never as copies. A copy silently diverges from the
repository and shadows later updates; the doctor reports it as a `COPY` defect.

Canonical link locations, each covering the harnesses that natively discover
it:

| Link directory | Consumed by |
|----------------|-------------|
| `~/.claude/skills/` | Claude Code (personal skills) |
| `~/.agents/skills/` | Codex CLI (USER tier) and pi (global discovery); both follow symlinks |

One link per skill directory, named after the skill, pointing to
`<toolkit>/skills/<name>/`. Every skill in the toolkit gets a link in **both**
locations — a partial deployment (new skill added to the repo but never
linked) is the most common drift and is invisible until the skill fails to
trigger.

During apply, create missing links idempotently and replace a stale or copied
entry only after showing it in the plan and backing it up. During verify, run
the doctor's `scripts/inspect-skill-links.sh --root <toolkit>` and require a
clean result. Do not deploy into harness-private legacy locations (e.g.
`~/.codex/skills/`) — Codex discovers `~/.agents/skills`, and a duplicate link
makes the same skill appear twice in its selector.

## Skill-owned configuration

When an installed Numados skill declares machine/project parameters, setup
must read that skill's configuration reference and delegate to its bundled
configurator. Show the logical profile, target project, parameter names,
destination files, backup behavior, and verification command in the setup
plan. Do not duplicate the parser or write profile files directly.

For `numados-knowledge-curator`, delegate vault/profile selection and
`NUMADOS_OBSIDIAN_KNOWLEDGE_ROOT` to `numados-obsidian-knowledge` and its
`scripts/configure-vault.sh`. Ask for the vault and a vault-relative existing
knowledge folder, plus whether the profile is project-selected or the machine
default. Apply only after confirmation, then run
`scripts/validate-vault-context.sh` and the curator doctor audit. Never infer
the knowledge root from `NUMADOS_OBSIDIAN_WRITE_ROOT`.

Apply must be idempotent, atomic where supported, backup before mutation, and
limited to declared targets. It may create a concise managed block in the
effective instruction file containing the minimum precedence rule and a
stable link to `contracts/context-precedence.md`. The link must resolve from
the installed location, an adjacent contract bundle, or a canonical URL; a
source-checkout-only absolute path is invalid. The full contract must not be
dumped into every context file.

## Environment and safety

Record environment variable names and whether required declarations are
present; never print values. Do not write credentials, auth files, global Git
hooks, Git aliases, or `core.hooksPath`. Native harness restrictions are the
only setup target for remote-write safety.

## Verification and rollback

Verification must prove native parsing and discovery rather than only file
existence. It must identify effective and shadowed sources and report
`UNKNOWN PRECEDENCE` when the harness cannot expose that result. Rollback must
use the recorded backup and avoid clobbering later user edits; if that cannot
be proven, stop and report the exact manual decision required.
