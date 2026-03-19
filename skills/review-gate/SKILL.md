---
name: "review-gate"
description: "Use when code or configuration is ready for a serious gate before merge or ship. Writes or appends `.codex/context/REVIEW.jsonl`, runs repo-local review agents, and emits a clear pass/fail status."
---

# Review Gate

Use this skill when implementation is done enough that correctness, regressions, and residual risk matter more than further feature work.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/REVIEW.jsonl`

Example schema:

- `$CODEX_HOME/templates/factory/REVIEW.jsonl.example`

## Workflow

1. Identify the changed boundary: files, feature path, service, or workflow.
2. Run a primary review using the repo-local `reviewer` agent or equivalent local review logic.
3. Add domain review if the repo pack includes it and it is relevant:
   - `security-auditor`
   - `performance-engineer`
   - `legal-advisor`
   - `fintech-engineer`
   - `llm-architect`
4. If and only if the user explicitly asked for delegation or a second opinion, parallelize independent review threads.
5. Append findings to `.codex/context/REVIEW.jsonl`.
6. Emit one final gate status:
   - `PASS`
   - `PASS_WITH_CONCERNS`
   - `FAIL`

## Review Entry Rules

Each JSONL line should capture:

- timestamp
- scope
- gate status
- severity
- short finding
- evidence
- smallest fix
- residual risk

## Guardrails

- Findings first, not summary first.
- Prefer precise evidence over broad warnings.
- If there are no findings, say so explicitly and still record residual risk or testing gaps.

