---
name: "eng-review"
description: "Use when an engineering governance lens should review maintainability, operability, integration quality, and long-term coherence before ship. This is a thin overlay on top of `review-gate`, not a replacement."
---

# Engineering Review

Use this skill when the repo needs a stronger engineering leadership lens before merge or ship.

This is a governance overlay. It does not replace `review-gate`.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/REVIEW.jsonl`
- `.codex/context/PLAN.md`
- `.codex/context/TESTPLAN.md`

## Workflow

1. Read `PLAN.md`, `TESTPLAN.md`, and the current code or config boundary.
2. Review from an engineering lens:
   - maintainability
   - integration quality
   - rollback and operability posture
   - boundary clarity
   - likely long-term debt
3. Append findings to `.codex/context/REVIEW.jsonl`.
4. Emit `PASS`, `PASS_WITH_CONCERNS`, or `FAIL`.

## What To Look For

- hidden coupling or unclear ownership boundaries
- rollout, rollback, or upgrade path gaps
- documentation or generated references drifting from the implementation
- complexity that is not justified by the shipped wedge
- missing tests or weak verification around risky integration edges

## Guardrails

- This is an overlay on top of `review-gate`, not a replacement for correctness review.
- Prefer system-level engineering risks over line-level style nitpicks.
- Keep findings tied to files, flows, and operational consequences.
