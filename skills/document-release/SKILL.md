---
name: "document-release"
description: "Use when shipped behavior, setup, operations, or external contracts changed and docs or release notes may now be stale. Updates `.codex/context/RELEASE.md` and the relevant repo docs."
---

# Document Release

This skill closes the loop after code changes. It keeps release notes, setup docs, and user-facing technical documentation aligned with what actually shipped.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/RELEASE.md`

Template source:

- `$CODEX_HOME/templates/factory/RELEASE.md`

## Workflow

1. Review the changed boundary and decide whether the change is:
   - user-visible
   - operator-visible
   - developer-visible
   - invisible but risky
2. Update or create `RELEASE.md`.
3. Update the smallest necessary doc surface:
   - README
   - setup / deployment docs
   - API docs
   - changelog or release notes
4. Make drift explicit when docs cannot be verified yet.

## What To Record

- summary of what changed
- user-visible impact
- technical or operational changes
- migrations or config changes
- deploy and rollback notes
- post-ship verification steps

## Guardrails

- Do not invent workflows or guarantees that the code does not support.
- Prefer fewer accurate doc edits over broad doc churn.
- If nothing user- or operator-visible changed, still decide whether `RELEASE.md` needs a minimal technical note.

