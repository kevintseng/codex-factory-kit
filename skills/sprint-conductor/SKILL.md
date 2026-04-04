---
name: "sprint-conductor"
description: "Use when work needs staged execution instead of a single freeform prompt. Builds or refreshes `.codex/context/PLAN.md` and `.codex/context/TESTPLAN.md`, maps local work vs delegated work, and routes to the right repo-local agents."
---

# Sprint Conductor

This skill turns a task into a small software factory run: plan, execute, validate, review, and document.

## Modes

### Lightweight mode

Use lightweight mode for small, low-risk, single-scope tasks.

In lightweight mode:

- create or refresh `.codex/context/PLAN.md`
- skip `PRODUCT.md` unless the request is vague
- skip `TESTPLAN.md` unless runtime verification is likely needed
- skip release and retro artifacts unless the task expands

### Full mode

Use full mode for multi-step work, risky work, multi-surface changes, or anything likely to need review, QA, or documentation updates.

## Artifact Paths

Prefer repo-local artifacts:

- `.codex/context/PLAN.md`
- `.codex/context/TESTPLAN.md`

Template source:

- `$CODEX_HOME/templates/factory/PLAN.md`
- `$CODEX_HOME/templates/factory/TESTPLAN.md`

## Workflow

1. Decide whether the task is lightweight mode or full mode.
2. Read existing `.codex/context/PRODUCT.md` if it exists.
3. If `factory-router` already ran, preserve and use the existing `Routing Snapshot` in `PLAN.md` and `TESTPLAN.md`.
4. Map the execution boundary: entry point, touched modules, external dependencies, and likely failure surface.
5. Write or refresh `PLAN.md`.
6. In full mode, write or refresh `TESTPLAN.md`.
7. Choose the minimum useful repo-local agents for the task.
8. If and only if the user explicitly wants delegation or parallel work, split ownership into disjoint workstreams and use subagents.
9. In full mode, route follow-up work to `review-gate`, `qa-runtime`, and `document-release` as appropriate.

## Subagent Routing Heuristics

- Use repo-local language or framework specialists first.
- Use repo-local domain agents when correctness risk is domain-heavy: fintech, legal, security, AI, or data.
- Use `reviewer` before merge-sensitive or risky edits.
- Use `qa-runtime` when a UI, route, or browser flow changed.
- Use `document-release` when user-visible behavior, setup, or external contracts changed.

## Output Requirements

`PLAN.md` should make these explicit:

- routing snapshot when router guidance already exists
- goal and scope
- smallest coherent change
- validation path
- risks and open questions
- local work vs delegated work

`TESTPLAN.md` should reflect the router's verification burden when a routing snapshot already exists.

## Guardrails

- Prefer staged execution over giant one-shot prompts.
- For small tasks, prefer lightweight mode over the full artifact chain.
- Prefer local work for the critical path.
- Only use subagents when the user has explicitly allowed delegated or parallel work.
- Do not let planning drift into architecture theater. Keep the next action obvious.
