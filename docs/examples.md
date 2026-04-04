# Usage Examples

## Example 1: Small Bug Fix

Task:

> Fix a small parsing bug in one module.

Recommended mode:

- lightweight mode

Expected artifacts:

- refresh `.codex/context/PLAN.md`

Expected flow:

1. optional `factory-router` if the route is not already obvious
2. `sprint-conductor`
3. implementation with repo-local agents
4. optional review if the risk rises

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
2. `factory-router`
3. `office-hours-codex` if the user intent is still vague
4. `sprint-conductor`
5. implementation with repo-local frontend or fullstack agents
6. `review-gate`
7. `qa-runtime`
8. `document-release`

Why:

- route behavior changed
- browser verification matters
- user-visible behavior may need docs or release notes
- router should classify this as full mode with browser verification and a stronger lead model path

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

1. `factory-router`
2. `office-hours-codex`
3. `sprint-conductor`
4. implementation with repo-local domain agents
5. `review-gate`
6. targeted runtime or integration verification
7. `document-release`
8. `retro`

Why:

- risk is domain-heavy
- review needs evidence
- rollout, rollback, and residual risk should be explicit
- the router should classify this as a strong path even if the code diff looks small

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

## Example 5: Route Before Coding

Task:

> I need to update a login funnel, verify it in the browser, and keep the implementation slices bounded.

Recommended first step:

- `factory-router`

Expected route:

- `mode: full`
- `needs_review_gate: true`
- `needs_qa_runtime: true`
- `subagent_strategy: bounded_parallel`
- `model_fit.lead_model_class: strong`
- `model_fit.worker_model_class: balanced`

Why:

- the task is multi-surface and browser-facing
- final routing, integration, and gating should stay on the stronger path
- bounded implementation slices can still be delegated to a balanced worker path

## Example 6: Refresh The Installed Kit

Task:

> I updated my local `codex-factory-kit` repo and want my installed `~/.codex` pack to match it.

Recommended first step:

- `factory-kit-upgrade`

Expected commands:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

Why:

- the upgrade foundation compares the repo `VERSION` with the installed metadata
- the release-check layer compares local versions with the latest published release
- the refresh targets only the selected `CODEX_HOME`
- the workflow does not overwrite repo-local `.codex/context/` artifacts or `~/.codex/AGENTS.md`

If the installed version is newer than the current checkout, the command refuses the overwrite unless you explicitly pass `--allow-downgrade`.

## Example 7: Keep A Risky Change Inside One Boundary

Task:

> Update one auth middleware path in a large repo and avoid collateral edits elsewhere.

Recommended mode:

- full mode with safety layer

Expected artifacts:

- `PLAN.md`
- `TESTPLAN.md`
- `FREEZE.md`
- `REVIEW.jsonl`

Expected flow:

1. `factory-router`
2. `freeze`
3. `sprint-conductor`
4. implementation inside the frozen scope
5. `guard`
6. `review-gate`

Why:

- the task is risky even if the intended scope is small
- the freeze contract makes the allowed edit boundary explicit
- the guard check turns “stay in this area only” into a real verification step
