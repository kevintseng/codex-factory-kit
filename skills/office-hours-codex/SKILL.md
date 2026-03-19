---
name: "office-hours-codex"
description: "Use when a request is still vague or product-shaped and needs reframing into a sharper problem statement, narrow wedge, constraints, and success criteria before implementation. Writes or refreshes `.codex/context/PRODUCT.md` using the global factory template."
---

# Office Hours Codex

Use this skill at the start of ambiguous product or feature work. The goal is to reduce a fuzzy request into a buildable wedge with clear user pain, constraints, and success conditions.

## Artifact Path

Prefer repo-local artifacts:

- `.codex/context/PRODUCT.md`

Template source:

- `$CODEX_HOME/templates/factory/PRODUCT.md`

Set once if needed:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
```

## Workflow

1. Restate the user's request in product terms, not implementation terms.
2. Challenge weak framing. Ask what pain is real, who has it, and what the smallest valuable wedge is.
3. Separate capabilities from implementation guesses.
4. Create or refresh `.codex/context/PRODUCT.md`.

## What Good Output Looks Like

- one clear problem statement
- one primary user
- a narrow first shipment
- explicit non-goals
- success and failure conditions
- the top risks that could make implementation misleading or wasteful

## Guardrails

- Prefer a narrower wedge over a long feature list.
- Do not confuse solution ideas with validated user pain.
- If the request is already implementation-ready, skip this skill and move to `sprint-conductor`.

