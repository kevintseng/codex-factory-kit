---
name: "founder-review"
description: "Use when a founder or product-owner governance lens should review user value, scope discipline, adoption fit, and messaging before ship. This is a thin overlay on top of `review-gate`, not a replacement."
---

# Founder Review

Use this skill when a founder, product-owner, or operator lens should check whether the change is worth shipping as described.

This is a governance overlay. It does not replace `review-gate`.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/REVIEW.jsonl`
- `.codex/context/RELEASE.md` when release framing matters

## Workflow

1. Read the shipped scope from `PLAN.md`, `RELEASE.md`, and user-facing docs when relevant.
2. Review from a founder/product lens:
   - user value
   - scope discipline
   - adoption friction
   - messaging honesty
   - whether the shipped wedge is concrete enough to matter
3. Append findings to `.codex/context/REVIEW.jsonl`.
4. Emit a gate result:
   - `PASS`
   - `PASS_WITH_CONCERNS`
   - `FAIL`

## What To Look For

- does the change solve a real user problem
- is the wedge crisp enough to justify the added complexity
- does the repo description of the feature match what actually shipped
- is there avoidable positioning or adoption friction
- are non-goals and boundaries still honest

## Guardrails

- This is an overlay on top of `review-gate`, not a replacement for correctness review.
- Ground findings in repo truth and shipped behavior, not strategy theater.
- Prefer concrete adoption or scope findings over vague product taste.
