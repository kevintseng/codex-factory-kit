---
name: "bootstrap-context"
description: "Use when a repo does not yet have `.codex/context/` artifacts and you want to initialize the factory files from the global templates before planning or implementation begins."
---

# Bootstrap Context

Use this skill once per repo, or any time a repo is missing the standard factory artifacts.

## Source Templates

Templates live here:

- `$CODEX_HOME/templates/factory/PRODUCT.md`
- `$CODEX_HOME/templates/factory/PLAN.md`
- `$CODEX_HOME/templates/factory/TESTPLAN.md`
- `$CODEX_HOME/templates/factory/RELEASE.md`
- `$CODEX_HOME/templates/factory/RETRO.md`
- `$CODEX_HOME/templates/factory/LEARNINGS.jsonl.example`
- `$CODEX_HOME/templates/factory/REVIEW.jsonl.example`

Set once if needed:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
```

## Target Layout

Create repo-local files under:

- `.codex/context/PRODUCT.md`
- `.codex/context/PLAN.md`
- `.codex/context/TESTPLAN.md`
- `.codex/context/REVIEW.jsonl`
- `.codex/context/RELEASE.md`
- `.codex/context/RETRO.md`
- `.codex/context/LEARNINGS.jsonl`

## Workflow

1. Check whether `.codex/context/` already exists.
2. Create any missing files from the global templates.
3. For `REVIEW.jsonl` and `LEARNINGS.jsonl`, create empty files instead of copying the example literally.
4. Do not overwrite filled-in repo artifacts unless the user explicitly asks.

## Guardrails

- This is initialization, not planning.
- Prefer creating only missing files.
- If the repo already has all artifacts, say so and stop.
