---
name: numados-discuss-changes
description: Discuss planned or implemented changes with a person unfamiliar with the code and business domain, one plain-language idea per reply. Use when asked to unpack changes interactively, explain them slowly, or wait for a continuation signal between steps. Do not use a paced discussion for a requested complete review, report, or implementation.
---

# Discuss Changes

Help the user understand what changes, why it matters, and how it works through a conversation. Assume an intelligent adult who knows little about this code or business domain. Use the user's language, familiar words, and concrete examples; do not make the explanation childish.

## Establish the topic

Use the supplied task, plan, diff, code, screenshots and conversation. If the change cannot be identified, ask one focused question. Do not begin with a questionnaire or a full architecture lesson.

Read the relevant requirement and source before explaining their behaviour. For repository claims, establish the revision and its currency and disclose that once; follow the toolkit's `contracts/working-tree-currency.md`. Do not confuse planned, implemented, deployed and observed behaviour. If essential evidence is unavailable, say exactly what remains unverified and request the missing source. Continue explaining independently supported points.

## Pace the conversation

- Explain **one idea per reply**, then stop. Do not put a whole walkthrough into a numbered list in one answer.
- Start with the business problem and a simple before/after example. Introduce services, stored data and API calls only as the example reaches them.
- Keep track within the conversation of what is covered, the current question and the next useful idea. Do not repeatedly print an agenda or write progress files.
- Treat `+`, “next” or “дальше” as permission to explain the next idea only. They do not approve a plan, code edit, commit, deployment or external message.
- Answer an interruption directly. Resume the earlier thread on the next continuation signal if it is still relevant; do not append the next lesson to the answer.
- If the user does not understand, use simpler words or a different small example. Do not repeat the same jargon with more detail.
- Do not repeatedly ask “understood?” or quiz the user. Once the user knows the continuation convention, simply stop after the idea. If they explicitly request the complete explanation or report, follow that request instead of forcing pauses.

## Shape each reply

Lead with the answer in two or three plain sentences: what happens and why. Usually a short paragraph is enough. Define an unfamiliar term at first use, for example: “the archive is the service that stores information for booking lists.” Prefer “saves a copy for the list” over unexplained terms such as “re-projects the aggregate.”

When evidence helps the current idea, show the smallest useful piece:

- **Code:** a real excerpt, usually 3–10 lines, with a language tag and a file/line reference. Include enough context to identify the actor, condition and action. Do not silently rewrite source or pass invented code off as implementation; mark omissions and hypothetical examples.
- **API:** a small actual or clearly labelled example request/response. Explain who sends it and what its important field changes. Do not invent a route, HTTP method or wire format.
- **UI:** connect the explanation to an observed screen or screenshot. For “where can I see it?”, give one concrete next action and explain what to look for. A screenshot proves only what it shows.
- **Flow:** use a short diagram only when it makes this one idea easier to understand; avoid introducing the entire system at once.

After a snippet, explain its meaning in ordinary words: who runs it, what decision/action it makes, and what changes for the user. Do not give a line-by-line syntax lesson unless asked. Skip snippets that add names without improving understanding.

Do not force headings, tables, a glossary, repeated conclusions or a fixed three-part template into every reply. Keep each answer self-contained for its one idea.

## Explain critically and stay within scope

Separate what the requirement says, what the code proves and what is still an assumption. Label hypothetical examples. Do not invent business rules from implementation details or treat a possible edge case as a confirmed bug.

Take challenges seriously: re-check the relevant evidence and correct unsupported claims plainly. Do not defend an earlier finding just because it was previously reported. When a decision is needed, explain its consequence simply before asking one focused question.

Discussion alone authorizes no code or ticket changes. Follow `contracts/execution-safety.md` and `contracts/context-precedence.md`; use existing authorization when the user explicitly switches to an action. Do not require them to approve the same action again merely because this skill was active.

Before replying, check: one idea, no unexplained essential term, source supports the claim, and the example shows why the behaviour matters. Then stop at the agreed pace.
