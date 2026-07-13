# Development Workflow Research

**Owner:** numados toolkit
**Reviewed:** 2026-07-13
**Scope:** Portable skills for evidence-first development from discovery through implementation review.

## Findings applied

- The Agent Skills specification keeps startup metadata small, loads the body only after activation, and defers detailed references until needed. The new skills therefore keep their main files short and use focused references.
- Mature open-source workflow skills separate discovery, design approval, planning, execution, verification, and completion. The new skills preserve those gates but remove assumptions about Jira, Claude sessions, a forge, branch naming, or mandatory subagents.
- Research and planning artifacts are compact durable handoffs, not transcripts. They carry only decision-relevant evidence, decisions, open questions, file boundaries, acceptance criteria, and verification results.
- The current-state index plus the latest immutable iteration event is the fast recovery path. Meaningful research, planning, implementation, and review transitions form an event chain; an agent follows detailed notes only when the latest event cannot answer the current question.
- Review remarks are kept in a separate `remarks.md`, while `research.md` and `plan.md` remain focused on discovery and the current design.
- Implementation phases are coherent and independently verifiable. A phase may have several atomic steps, but it must leave a reviewable state and a clear commit boundary.
- Review is a loop, not a final paragraph: inspect the actual diff, verify each candidate finding, fix only confirmed in-scope issues, re-run the review, and stop only when clean or blocked by named missing evidence.
- Planning can extend an approved plan when current evidence reveals missing work; completed phase IDs remain stable, and scope-changing additions require user approval.
- `numados-task-navigator` is read-only by default and starts from `_task_index.md` plus `latest_iteration` before following research, plan, remarks, source, or history links.

## Sources

- [Agent Skills specification](https://agentskills.io/specification)
- [agentskills/agentskills](https://github.com/agentskills/agentskills)
- [obra/superpowers brainstorming](https://github.com/obra/superpowers/blob/main/skills/brainstorming/SKILL.md)
- [obra/superpowers writing-plans](https://github.com/obra/superpowers/blob/main/skills/writing-plans/SKILL.md)
- [obra/superpowers executing-plans](https://github.com/obra/superpowers/blob/main/skills/executing-plans/SKILL.md)
- [obra/superpowers subagent-driven-development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md)
- [Anthropic document co-authoring skill](https://github.com/anthropics/skills/blob/main/skills/doc-coauthoring/SKILL.md)
- [GitHub Agentic Workflows research-plan-assign-ops pattern](https://github.github.com/gh-aw/patterns/task-ops/)

The sources are references for design ideas, not dependencies of the portable skills.
