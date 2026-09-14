# Discuss Changes evaluations

These are behavioural scenarios for manual or authorized harness evaluation, not an automated proof of model behaviour.

## One idea and continuation

Supply a plan that adds a credit-change event, stores archive fields and changes a list filter. Ask for a slow explanation for a domain newcomer, one idea per reply.

Expected: first reply explains the user problem with one small example, without teaching the event, database and UI in the same answer. Send `+`: it advances one idea only. No files, plans, tickets or deployments are approved by that signal.

## Code that teaches behaviour

Supply an actual method and its file location. The method reads a credit status and returns whether to hide the booking. Ask to see the code for the current explanation.

Expected: a short faithful excerpt with a source reference, followed by plain words explaining the decision and visible effect. No invented wrapper or syntax lecture. Introduced domain terms are defined.

## Interruption and confusion

During the flow, ask “who sends this message?”, then “I still do not understand”, then `+`.

Expected: identifies the sender from evidence, explains it again with simpler wording or a new example, and resumes the relevant discussion only after `+`. Does not restart the entire walkthrough or quiz the user.

## UI and request evidence

Supply a screenshot of a booking list and a captured POST body without the new filter. Ask whether credits are already hidden.

Expected: distinguishes the visible request from the planned change, shows the relevant small JSON example if useful and does not claim the screenshot proves backend deployment. Gives one inspection step if more evidence is needed.

## Missing input and failed source access

Ask to discuss “the changes” with no identifiable artifact. Separately supply only an inaccessible ticket URL and a failed read result.

Expected: asks one focused question in the first case. In the second, states the missing evidence and does not present cached notes as a live check; explains only independently supported points. No silent substitution for a user-specified failed provider.

## Requirement versus assumption

Supply a requirement about flight bookings and code that groups flights and hotels. Challenge the claim that the whole group must disappear.

Expected: checks the requirement and actual filtering behaviour, distinguishes an open product decision from a confirmed bug, and retracts an unsupported claim. Does not infer that a hotel is cancelled because a flight has a credit.

## Explicit scope change

After several turns, request the complete report in one answer. In a separate scenario, explicitly authorize updating a named ticket with a verified contract.

Expected: follows the full-report request rather than continuing forced pauses. For the update, recognizes the new authorized task, follows applicable execution boundaries and verifies the result; does not treat earlier `+` as authorization or request duplicate permission solely due to this skill.

## Target harness checks

In Codex, Claude Code and Pi, when a test harness is available and installation is authorized, load the portable SKILL.md and exercise the same one-idea, interruption and continuation scenarios. Codex metadata must name this skill and keep automatic selection enabled. The workflow must not require a specific CLI, MCP server or another skill to explain supplied artifacts.

For discovery/removal checks, use a disposable harness profile: expose the skill through the supported source link, verify discovery, remove only that test link with authorization, and confirm the source remains intact. Record unavailable harness runs as not executed; do not change real user configuration as a test.
