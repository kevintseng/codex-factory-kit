# Concrete Demo

This is a compact example of what Codex Factory Kit looks like on a real task.

## Task

> Fix a flaky checkout route that sometimes shows success before payment confirmation is actually complete.

This is not a trivial one-file change:

- there is user-visible behavior
- there is backend state involved
- there is risk of claiming success too early
- runtime verification matters

So this should use the full loop, not lightweight mode.

## Before

Without a workflow layer, a typical AI coding session often looks like this:

- patch a handler or UI route directly
- maybe run a test
- maybe open the browser
- finish without durable review evidence
- next session has to reconstruct what changed and what still feels risky

That is exactly the failure mode this kit is trying to reduce.

## After

With Codex Factory Kit, the same task leaves behind durable artifacts.

### `PLAN.md`

Example shape:

```md
# Execution Plan

## Goal
- Stop the checkout flow from showing a success state before payment confirmation is durable.

## Scope
- In scope:
  - checkout success route
  - payment status polling / reconciliation
  - UI success gating
- Out of scope:
  - payment provider migration
  - pricing logic changes

## Validation
- Primary success path:
  - confirmed payment shows success
- Representative failure path:
  - pending payment does not show success
- Integration edge:
  - delayed provider callback does not create a false positive state

## Risks And Open Questions
- Risk 1:
  - UI and backend may disagree about final payment state
```

### `TESTPLAN.md`

Example shape:

```md
# Test Plan

## Critical Paths
- successful checkout after confirmed payment

## Failure Paths
- checkout page refresh while payment is still pending
- delayed payment provider callback

## Checks To Run
- Unit / package checks:
  - payment state mapping tests
- End-to-end / browser checks:
  - verify success route only appears after confirmation
- Manual verification:
  - simulate slow callback timing

## Evidence
- Command:
  - pnpm test
- Output summary:
  - checkout status tests pass
- Screenshot / artifact:
  - browser screenshot showing pending state before confirmation
```

### `REVIEW.jsonl`

Example shape:

```json
{"ts":"2026-03-19T00:00:00Z","scope":"checkout","status":"PASS_WITH_CONCERNS","severity":"medium","finding":"UI route still trusts a stale client-side flag in one fallback path","evidence":"apps/web/app/checkout/success/page.tsx:88","fix":"Gate success rendering on confirmed backend payment state","residual_risk":"Partial browser states may still need manual verification"}
```

### `RELEASE.md`

Example shape:

```md
# Release Notes

## Summary
- Checkout success is now gated on confirmed payment completion.

## User-Visible Changes
- Users no longer see a false success state while payment is still pending.

## Risk
- Deployment risk:
  - moderate, touches checkout state transitions
- Rollback plan:
  - revert success gating change if payment confirmation path regresses
```

## Why This Matters

The value is not the filenames by themselves.

The value is that:

- planning is explicit
- QA has evidence
- review has durable findings
- release risk is written down
- the next session does not start from zero

That is the difference between "Codex helped with a patch" and "Codex participated in a repeatable engineering workflow."
