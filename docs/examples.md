# Usage Examples

## Example 0: Task Routing

Task:

> I need to update a signup flow, but I am not sure whether this should stay lightweight or use the full factory loop.

Recommended first step:

- `factory-router`

Expected outcome:

- a routing decision for `lightweight` or `full`
- a clear list of required next skills
- explicit reasoning tied to risk and verification burden

Why:

- the first question is not implementation
- the user needs workflow selection before deeper execution starts

## Example 1: Small Bug Fix

Task:

> Fix a small parsing bug in one module.

Recommended mode:

- lightweight mode

Expected artifacts:

- refresh `.codex/context/PLAN.md`

Expected flow:

1. `sprint-conductor`
2. implementation with repo-local agents
3. optional review if the risk rises

Why:

- single-scope task
- no browser verification required
- no release note or retro needed unless the work expands

## Example 2: UI Workflow Change

Task:

> Update a signup funnel and verify the happy path in the browser.

Recommended mode:

- full mode

Expected artifacts:

- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`

Expected flow:

1. `bootstrap-context` if needed
2. `office-hours-codex` if the user intent is still vague
3. `sprint-conductor`
4. implementation with repo-local frontend or fullstack agents
5. `review-gate`
6. `qa-runtime`
7. `document-release`

Why:

- route behavior changed
- browser verification matters
- user-visible behavior may need docs or release notes

## Example 3: Risky Backend Change

Task:

> Change a payment or security-sensitive backend flow.

Recommended mode:

- full mode

Expected artifacts:

- `PRODUCT.md` if requirements are not sharp
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`

Expected flow:

1. `office-hours-codex`
2. `sprint-conductor`
3. implementation with repo-local domain agents
4. `review-gate`
5. targeted runtime or integration verification
6. `document-release`
7. `retro`

Why:

- risk is domain-heavy
- review needs evidence
- rollout, rollback, and residual risk should be explicit

## Example 4: Multi-Session Feature Work

Task:

> Build a feature over several sessions without losing context.

Recommended mode:

- full mode

Expected benefit:

- the next session reads the repo-local artifacts instead of rebuilding the context from memory

Most useful files:

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RETRO.md`
