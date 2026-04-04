---
name: "release-review"
description: "Use when a release-readiness governance lens should review versioning, changelog accuracy, rollout safety, upgrade impact, and release-note honesty before ship. This is a thin overlay on top of `review-gate`, not a replacement."
---

# Release Review

Use this skill when the change is near merge or ship and release-readiness deserves its own explicit lens.

This is a governance overlay. It does not replace `review-gate`.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/REVIEW.jsonl`
- `.codex/context/RELEASE.md`
- `CHANGELOG.md`
- `VERSION`

## Workflow

1. Read the current release notes, changelog, version state, and any install/upgrade impact.
2. Review from a release lens:
   - release-note honesty
   - versioning discipline
   - rollout and rollback posture
   - upgrade or migration impact
   - whether the change actually deserves a release
3. Append findings to `.codex/context/REVIEW.jsonl`.
4. Emit `PASS`, `PASS_WITH_CONCERNS`, or `FAIL`.

## What To Look For

- changelog entries that do not match shipped behavior
- version bumps or release language that overstate the real improvement
- missing rollback or upgrade guidance for user-visible lifecycle changes
- release-worthy changes being mixed with docs-only or internal-only work
- gaps between generated install/upgrade references and the actual command surface

## Guardrails

- This is an overlay on top of `review-gate`, not a replacement for correctness review.
- Ground findings in the actual shipped diff, not hypothetical roadmap work.
- Keep the repo's release policy intact: only real functional improvements, meaningful features, or real bug fixes should drive releases.
