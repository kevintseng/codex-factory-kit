# Codex Factory Kit

Codex Factory Kit is a Codex-native workflow layer for people who want more than a loose collection of prompts.

It turns larger tasks into a staged loop:

1. bootstrap context
2. sharpen the problem
3. plan execution
4. implement with repo-local agents
5. gate with structured review
6. verify at runtime
7. update release notes and docs
8. write a retro

It also includes a lightweight mode for small tasks so you do not pay the full process cost every time.

## What Is Included

- global skills for Codex:
  - `bootstrap-context`
  - `office-hours-codex`
  - `sprint-conductor`
  - `review-gate`
  - `qa-runtime`
  - `document-release`
  - `retro`
- factory templates:
  - `PRODUCT.md`
  - `PLAN.md`
  - `TESTPLAN.md`
  - `REVIEW.jsonl.example`
  - `RELEASE.md`
  - `RETRO.md`
- a suggested global `AGENTS.md` policy
- an installer that copies skills and templates into `~/.codex`

## Why

The main idea is simple: persistent artifacts beat re-explaining the task every turn.

Instead of asking Codex to hold the whole project in short-term context every time, keep working artifacts in `.codex/context/` inside each repo:

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`

This makes handoffs, review, QA, and follow-up work materially more stable.

## Install

Clone this repo somewhere local, then run:

```bash
./install.sh
```

This installs:

- `skills/*` into `~/.codex/skills/`
- `templates/factory/*` into `~/.codex/templates/factory/`
- `AGENTS.md` into `~/.codex/AGENTS.factory-kit.md`

The installer does not overwrite your existing `~/.codex/AGENTS.md`.

If you want to adopt the suggested global policy, merge or replace it manually:

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

Only do that if you want this workflow to become your default Codex operating model.

## Per-Repo Adoption

Inside a repo, initialize:

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PRODUCT.md .codex/context/PRODUCT.md
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
cp ~/.codex/templates/factory/TESTPLAN.md .codex/context/TESTPLAN.md
cp ~/.codex/templates/factory/RELEASE.md .codex/context/RELEASE.md
cp ~/.codex/templates/factory/RETRO.md .codex/context/RETRO.md
: > .codex/context/REVIEW.jsonl
printf '\n.codex/context/\n' >> .gitignore
```

You can also use the `bootstrap-context` skill to do this incrementally without overwriting existing artifacts.

## Default Loop

Use the full loop when the task is multi-step, risky, or touches multiple surfaces:

1. `bootstrap-context`
2. `office-hours-codex` for vague asks
3. `sprint-conductor`
4. implementation with repo-local agents
5. `review-gate`
6. `qa-runtime`
7. `document-release`
8. `retro`

## Lightweight Mode

Use lightweight mode when all of these are true:

- the change is small and bounded
- no browser or multi-surface verification is obviously needed
- no infra, migration, legal, security, or fintech risk is involved

In lightweight mode:

1. skip `office-hours-codex` unless the ask is vague
2. use `sprint-conductor` only to refresh `PLAN.md`
3. skip `TESTPLAN.md`, `RELEASE.md`, and `RETRO.md` unless the task grows
4. skip `review-gate` for trivial local work unless risk rises

## Publishing Model

This repo intentionally does not include private repo-local agent packs or personal project context. It is the reusable layer only.

## Layout

```text
.
├── AGENTS.md
├── install.sh
├── skills/
│   ├── bootstrap-context/
│   ├── office-hours-codex/
│   ├── sprint-conductor/
│   ├── review-gate/
│   ├── qa-runtime/
│   ├── document-release/
│   └── retro/
└── templates/
    └── factory/
```

## License

MIT
