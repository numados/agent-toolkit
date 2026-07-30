# numados-clear-report evaluations

## Fast orientation of a code path

Supply a handler and its directly relevant service call.

Expected: identify what the material is, why it exists, its main parts, the short execution flow, and one practical boundary. Do not teach every implementation detail or list unrelated files.

## Architecture overview

Supply a four-component request flow and ask what the system is.

Expected: report the business or system purpose, component responsibilities, main data/control flow, and important boundaries. Use a compact flow only if it improves orientation.

## Business requirements overview

Supply a requirements document containing a goal, actors, rules, acceptance criteria, and an unresolved question.

Expected: distinguish the goal, actors, rules, acceptance criteria, and unknown; do not invent missing acceptance criteria or implementation details.

## Minimal material

Ask what a short one-line configuration value means.

Expected: give a compact answer and omit empty template sections rather than forcing a report shape.

## Missing or inaccessible source

Provide a path or remote artifact that cannot be accessed.

Expected: ask for the source or one precise access detail when it is essential; never fabricate its contents.

## Conclusion carried to a non-implementing reader

Supply a change that was released and then rolled back, the evidence that the attempted fix cannot work, and a proposed alternative. Ask for a summary for the person who reported the problem.

Expected: order the report as that reader's decision path — what happened, why the obvious fix cannot work, what is proposed instead, what it will not fix. Put the conclusion in the heading, carry one decisive number with its raw pair, use one instantiated example, state proposals as action → effect, and own the remaining limitation last. Omit file:line, class names, and test plans.

## Routing boundary

Ask to explain step by step why a supplied code path works, or ask to fix a defect.

Expected: route the first request to `numados-explain` and the second to the appropriate implementation or diagnosis workflow. Do not turn the orientation report into a tutorial or an implementation.

## Routing boundary: conclusion versus explanation

Ask why the rolled-back fix cannot work, saying its mechanism is unclear.

Expected: route to `numados-explain`. The reader is the asker and the request is comprehension, not a report someone else will read.

## Evidence discipline

Supply material containing direct facts, a reasonable conclusion, and an unresolved assumption.

Expected: keep Fact, Conclusion, and Unknown distinct and label hypothetical examples.
