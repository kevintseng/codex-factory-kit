---
name: "freeze"
description: "Use when the blast radius should stay deliberately narrow. Creates or refreshes `.codex/context/FREEZE.md` with allowed paths, blocked paths, and protected invariants before implementation continues."
---

# Freeze

Use this skill before risky or scope-sensitive implementation when the task should stay inside an explicit boundary.

This is a safety-layer skill. It does not replace planning or review. It makes the intended edit boundary concrete before code changes continue.

## Artifact Path

Create or refresh:

- `.codex/context/FREEZE.md`

Template source:

- `$CODEX_HOME/templates/factory/FREEZE.md`

## When To Use

Use `freeze` when any are true:

- the user wants the blast radius minimized
- the repo is large and accidental collateral edits are likely
- the task should stay inside one subsystem, directory, or file family
- the router suggests `freeze` before implementation

## Workflow

1. Identify the narrow scope that should be allowed.
2. List the allowed paths explicitly in `.codex/context/FREEZE.md`.
3. List blocked paths that must not be touched.
4. Record the key invariants that must remain true.
5. Record exit criteria so the boundary can be refreshed or removed deliberately.
6. Hand the frozen scope forward to implementation and to `guard`.

## Output Requirements

`FREEZE.md` should make these explicit:

- the intent of the narrow scope
- allowed paths
- blocked paths
- protected invariants
- exit criteria

## Guardrails

- This is a scoped safety contract, not a hidden lock.
- Keep the allowed path set as small as the task realistically allows.
- If the work genuinely needs to expand, refresh `FREEZE.md` before continuing instead of silently drifting.
- Do not use `freeze` to skip review, QA, or documentation obligations that still apply.
