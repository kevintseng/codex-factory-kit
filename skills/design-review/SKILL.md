---
name: "design-review"
description: "Use when a design or workflow-UX governance lens should review clarity, ergonomics, naming, and user-facing coherence before ship. This is a thin overlay on top of `review-gate`, not a replacement."
---

# Design Review

Use this skill when the shipped change needs a stronger design, UX, or workflow-ergonomics lens.

This is a governance overlay. It does not replace `review-gate`.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/REVIEW.jsonl`
- `.codex/context/PLAN.md`
- `.codex/context/RELEASE.md`

## Workflow

1. Read the current shipped flow from `PLAN.md`, release notes, and user-facing docs.
2. Review from a design lens:
   - clarity
   - workflow ergonomics
   - naming and mental model fit
   - consistency across docs and command surface
   - user-visible friction
3. Append findings to `.codex/context/REVIEW.jsonl`.
4. Emit `PASS`, `PASS_WITH_CONCERNS`, or `FAIL`.

## What To Look For

- confusing command names or artifact names
- user-facing docs that explain the feature differently than the actual behavior
- workflow steps that are hard to discover or easy to misuse
- noisy or cluttered public surfaces that weaken understanding
- missing examples for important behavior changes

## Guardrails

- This is an overlay on top of `review-gate`, not a replacement for correctness review.
- Prefer concrete clarity or ergonomics findings over subjective aesthetic commentary.
- Keep the lens grounded in actual user interaction with the repo and workflow.
