---
name: "factory-router"
description: "Use when a task needs to be routed into the right Codex Factory Kit workflow path. Classify work into lightweight mode or the full loop, decide which factory skills are needed next, and explain the reasoning."
---

# Factory Router

Use this skill when the user is not sure which factory path to use, or when a non-trivial task should be classified before deeper work starts.

This is the first vNext wedge: a rule-based capability router.

It does not replace Codex platform primitives, and it does not claim platform-level enforcement. It provides soft orchestration and clear next-step guidance.

## When To Use

Use this skill when any of these are true:

- the task may be larger than a trivial one-step edit
- it is unclear whether the task should stay lightweight or use the full loop
- you need to decide whether to invoke `office-hours-codex`
- you need to decide whether to refresh only `PLAN.md` or both `PLAN.md` and `TESTPLAN.md`
- you need to decide whether `review-gate`, `qa-runtime`, `document-release`, or `retro` should be used next
- the user explicitly asks how to route or govern the work

## Output Contract

Emit a compact routing decision with these fields:

- `mode`: `lightweight | full`
- `needs_bootstrap_context`: boolean
- `needs_office_hours`: boolean
- `needs_plan`: boolean
- `needs_testplan`: boolean
- `needs_review_gate`: boolean
- `needs_qa_runtime`: boolean
- `needs_document_release`: boolean
- `needs_retro`: boolean
- `subagent_strategy`: `none | bounded_parallel | review_only`
- `cloud_delegate_strategy`: `none | suggest`
- `reasoning`: short human-readable explanation
- `next_steps`: ordered list of the next concrete actions or skills

Present the decision in a small markdown code block or a compact bullet list, then summarize the route in plain language.

## Routing Rules

### Lightweight Mode

Use `lightweight` when all are true:

- the task is small and bounded
- one scope or one clear path is involved
- no browser QA or multi-surface verification is obviously needed
- no migration, infra, legal, security-sensitive, or fintech risk is involved

### Full Loop

Use `full` when any are true:

- the task is multi-step
- the change crosses multiple surfaces
- runtime or deployment behavior changed
- auth, billing, security, infra, migration, or release posture is involved
- the work is merge-sensitive or ship-sensitive

### Office Hours

Require `office-hours-codex` when the request is still vague, product-shaped, or underspecified.

### Plan And Test Plan

- Require `PLAN.md` for non-trivial work.
- Require `TESTPLAN.md` when runtime verification, browser QA, integration behavior, or higher-risk work is involved.

### Review Gate

Require `review-gate` when:

- the work is materially risky
- auth, billing, security, infra, or migration concerns exist
- the change is merge-sensitive or ship-sensitive

### QA Runtime

Require `qa-runtime` when:

- UI, browser, route, or end-to-end behavior changed
- a runtime claim would otherwise be unverified

### Document Release

Require `document-release` when:

- shipped behavior changed
- setup, operations, contracts, or public docs changed

### Retro

Require `retro` when:

- a major workflow step completed
- the task exposed process or tooling gaps worth preserving

### Subagents

Use `bounded_parallel` only when:

- the user explicitly allows delegation or parallel work
- at least two independent subproblems exist
- the critical path can still move locally

Otherwise keep the critical path local.

### Cloud Delegate

This repo does not ship cloud delegation behavior. Use only:

- `none`
- `suggest` when a task is long-running and background-friendly

## Follow-Through Rule

If the user asked only for routing or advice, stop after emitting the routing decision.

If the user asked to proceed end-to-end and the next action is non-destructive, continue into the routed next step after the decision:

1. `bootstrap-context` if `.codex/context/` is missing
2. `office-hours-codex` if needed
3. `sprint-conductor` for implementation planning

## Guardrails

- Do not present the router as hard enforcement.
- Do not claim cloud orchestration, worktree orchestration, or model-fit routing unless those capabilities are actually shipped.
- Never auto-trigger destructive actions.
- Keep the reasoning explicit and tied to task shape, risk, and verification burden.
