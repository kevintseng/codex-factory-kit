---
name: "retro"
description: "Use after a ship, major workflow step, or completed task to write or refresh `.codex/context/RETRO.md` with what shipped, what broke, what slowed the work down, and what tooling or agent gaps were exposed."
---

# Retro

Use this skill to close the loop after significant work. The goal is not ceremony. The goal is to capture what shipped, what hurt, and what should change next time.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/RETRO.md`

Template source:

- `$CODEX_HOME/templates/factory/RETRO.md`

## Workflow

1. Read the available context:
   - recent task summary
   - `PLAN.md`
   - `TESTPLAN.md`
   - `REVIEW.jsonl`
   - `RELEASE.md`
2. Summarize what actually shipped or completed.
3. Record:
   - what went well
   - what broke or slowed execution down
   - follow-up debt
   - missing agent or tooling support
4. Update `RETRO.md`.

## What To Capture

- the real outcome, not the intended one
- the top friction points
- what verification caught late
- which agent instructions were strong or weak
- the next concrete setup improvement

## Guardrails

- Prefer specific friction over vague sentiment.
- Keep the retro honest and operational.
- If the task was tiny and no meaningful retro exists, record that briefly and stop.

