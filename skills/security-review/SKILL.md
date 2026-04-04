---
name: "security-review"
description: "Use when a security governance lens should review trust boundaries, secrets handling, mutation safety, and abuse surface before ship. This is a thin overlay on top of `review-gate`, not a replacement."
---

# Security Review

Use this skill when the change needs a sharper security or trust-boundary lens before merge or ship.

This is a governance overlay. It does not replace `review-gate`.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/REVIEW.jsonl`
- `.codex/context/TESTPLAN.md`
- `.codex/context/FREEZE.md` when the scope was deliberately narrowed

## Workflow

1. Read the changed boundary, verification plan, and any freeze contract.
2. Review from a security lens:
   - trust boundaries
   - auth and permissions
   - secrets handling
   - unintended mutation surface
   - abuse and downgrade paths
3. Append findings to `.codex/context/REVIEW.jsonl`.
4. Emit `PASS`, `PASS_WITH_CONCERNS`, or `FAIL`.

## What To Look For

- silent overwrite or mutation risks
- incorrect assumptions about install roots, permissions, or source authority
- missing guardrails around dangerous commands or risky workflow paths
- leakage of internal-only material into public surfaces
- verification gaps around security-sensitive behavior

## Guardrails

- This is an overlay on top of `review-gate`, not a replacement for correctness review.
- Prefer concrete attack surface or misuse findings over generic best-practice slogans.
- Stay repo-truth-first and do not invent threats that the code path does not expose.
