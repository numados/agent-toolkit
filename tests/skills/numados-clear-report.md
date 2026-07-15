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

## Routing boundary

Ask to explain step by step why a supplied code path works, or ask to fix a defect.

Expected: route the first request to `numados-explain` and the second to the appropriate implementation or diagnosis workflow. Do not turn the orientation report into a tutorial or an implementation.

## Evidence discipline

Supply material containing direct facts, a reasonable conclusion, and an unresolved assumption.

Expected: keep Fact, Conclusion, and Unknown distinct and label hypothetical examples.
