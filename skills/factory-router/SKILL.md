---
name: "factory-router"
description: "Use when a task needs an explicit route before implementation. Classifies the task into lightweight or full mode, declares required downstream skills, and adds model-fit guidance to the same routing envelope."
---

# Factory Router

Use this skill at the start of non-trivial work when the task needs a clear route before implementation begins.

This skill does not replace the existing factory loop. It decides how the loop should be used.

## Responsibilities

The router decides or suggests:

- lightweight mode or full mode
- whether to invoke `office-hours-codex`
- whether to refresh `PLAN.md` only or both `PLAN.md` and `TESTPLAN.md`
- whether `review-gate`, `qa-runtime`, `document-release`, and `retro` are required
- whether the work should stay local or be split into bounded parallel slices
- whether cloud or background delegation is worth suggesting
- which model class should lead the work and which class can safely execute bounded slices
- whether prior reusable learnings should tighten review, QA, release, or safety expectations

## Inputs

Inspect these signals:

- user request shape
- scope size and number of likely touched surfaces
- repo signals such as UI, route, release, auth, migration, infra, billing, or security impact
- verification burden implied by the task
- whether there are independent bounded slices
- relevant entries from `.codex/context/LEARNINGS.jsonl` when that store exists

## Canonical Routing Envelope

The router should emit one stable envelope. Model-fit guidance extends that envelope instead of creating a second competing schema.

Required fields:

- `mode`: `lightweight | full`
- `needs_office_hours`: boolean
- `needs_plan`: boolean
- `needs_testplan`: boolean
- `needs_review_gate`: boolean
- `needs_qa_runtime`: boolean
- `needs_document_release`: boolean
- `needs_retro`: boolean
- `suggest_freeze`: boolean
- `suggest_guard`: boolean
- `subagent_strategy`: `none | bounded_parallel | review_only`
- `cloud_delegate_strategy`: `none | suggest`
- `task_class`: short stable label such as `small_fix`, `multi_surface_feature`, `risky_backend_change`
- `complexity_level`: `low | medium | high`
- `risk_level`: `low | medium | high`
- `verification_level`: `minimal | targeted | runtime | browser`
- `model_fit.lead_model_class`: `light | balanced | strong`
- `model_fit.worker_model_class`: `light | balanced | strong | none`
- `suggest_freeze`: whether the task should scope-lock edits before implementation
- `suggest_guard`: whether the current diff should be checked against a freeze contract before final gate
- `reasoning`: short human-readable explanation

Example:

```json
{
  "mode": "full",
  "needs_office_hours": false,
  "needs_plan": true,
  "needs_testplan": true,
  "needs_review_gate": true,
  "needs_qa_runtime": true,
  "needs_document_release": true,
  "needs_retro": true,
  "suggest_freeze": true,
  "suggest_guard": true,
  "subagent_strategy": "bounded_parallel",
  "cloud_delegate_strategy": "none",
  "task_class": "multi_surface_feature",
  "complexity_level": "medium",
  "risk_level": "medium",
  "verification_level": "browser",
  "model_fit": {
    "lead_model_class": "strong",
    "worker_model_class": "balanced"
  },
  "reasoning": "The task spans implementation, review, and browser verification. Planning and final integration should stay on the stronger path while bounded slices can be executed on a balanced worker path."
}
```

## Trigger Matrix

### Route to `lightweight`

Use when all are true:

- one clear scope or one clear path
- low risk
- no browser or multi-surface verification is obviously needed
- no migration, infra, auth, billing, deployment, legal, or security-sensitive impact

### Route to `full`

Use when any are true:

- multi-step work
- cross-surface changes
- route, UI, or runtime behavior changes
- auth, billing, migration, infra, deployment, or security concerns exist
- merge-sensitive or ship-sensitive work

### Require `office-hours-codex`

Use when:

- the task is still vague
- product or scope uncertainty is the main blocker
- success criteria are not yet concrete

### Require `review-gate`

Use when:

- correctness, regression, or release risk is material
- auth, security, billing, infra, or migration work is involved
- the work is merge-sensitive or ship-sensitive

### Require `qa-runtime`

Use when:

- route, browser, or UI behavior changed
- runtime claims would otherwise be unverified

### Require `document-release`

Use when:

- shipped behavior changed
- setup, operations, or public docs changed

### Route to bounded parallel work

Use `subagent_strategy: bounded_parallel` only when:

- at least two independent slices exist
- ownership can be kept disjoint
- the critical path can continue locally

Use `subagent_strategy: review_only` when:

- implementation should stay local
- but an independent review pass is worth running

### Suggest cloud delegation

Use only when:

- the work is long-running and background-friendly
- the user does not need the result for the immediate next local step

Keep this at `suggest`, not hard execution.

## Model-Fit Policy

### `light`

Use for:

- tiny edits
- low-risk single-path work
- documentation updates after the contract is already known

### `balanced`

Use for:

- medium feature slices
- bounded cross-file work
- well-scoped implementation that still needs competence

### `strong`

Use for:

- routing and decomposition
- architecture and integration
- auth, security, migration, billing, release, or runtime-truth work
- final review and ship gates

Default mixed strategy:

- strong model routes and integrates
- balanced or light worker executes bounded slices
- strong model performs final gate decisions

## Artifact Integration

When the router runs before implementation:

1. Refresh or add a `Routing Snapshot` section in `.codex/context/PLAN.md`.
2. If `.codex/context/LEARNINGS.jsonl` exists, consult the relevant active learnings and use `learn sync-context` to carry the useful ones into the current plan artifacts.
3. If `needs_testplan` is true, refresh or add the matching routing and verification posture in `.codex/context/TESTPLAN.md`.
4. If `suggest_freeze` is true, carry that into the routing snapshot and route to `freeze` before implementation starts.
5. If `suggest_guard` is true, carry that into the routing snapshot and route to `guard` before the final review or completion summary.
6. Pass the route forward to `sprint-conductor` so the execution plan and verification plan inherit the same assumptions.

The snapshot should capture:

- mode
- task class
- complexity, risk, and verification levels
- model-fit choice
- relevant learnings when they materially change workflow expectations
- freeze / guard recommendation
- required downstream skills

## Workflow

1. Inspect the request and repo signals.
2. Emit the canonical routing envelope.
3. Update the routing snapshot in `PLAN.md`, and in `TESTPLAN.md` when required.
4. Route to the next skill:
   - `office-hours-codex` when the ask is still vague
   - `freeze` when the blast radius should be scope-locked before implementation
   - `sprint-conductor` when implementation should proceed
5. Keep later gates explicit instead of implied.

## Guardrails

- Prefer the safer path when confidence is low.
- Do not invent platform interception or hidden automation.
- Do not auto-trigger destructive or irreversible actions.
- Keep the first route explainable to a human reviewer.
