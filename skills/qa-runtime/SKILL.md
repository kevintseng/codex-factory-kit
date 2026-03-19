---
name: "qa-runtime"
description: "Use when a browser flow, route, UI, or end-to-end workflow needs runtime verification. Uses the existing Playwright skills and records concrete checks in `.codex/context/TESTPLAN.md`."
---

# QA Runtime

This skill is for real runtime verification, not static code inspection.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/TESTPLAN.md`

Template source:

- `$CODEX_HOME/templates/factory/TESTPLAN.md`

## Workflow

1. Read `TESTPLAN.md` if it exists. If not, create it from the template.
2. Identify:
   - critical user path
   - representative failure path
   - one integration edge
3. For browser work, prefer the existing `playwright` or `playwright-interactive` skill already installed in this environment.
4. Capture evidence:
   - command run
   - result summary
   - screenshot or artifact path when useful
5. Update `TESTPLAN.md` with what passed, what failed, and what remains unverified.

## What To Verify

- the happy path actually works
- one failure path fails clearly and safely
- one integration edge still behaves correctly
- runtime state matches user-visible messaging

## Guardrails

- Do not mark a flow verified without runtime evidence.
- Prefer small targeted checks over broad wandering QA.
- If a live URL or auth is required and missing, stop and mark the gap explicitly.

