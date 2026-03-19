# Codex Factory Kit

Codex Factory Kit is a Codex-native workflow layer for people who want more than a loose collection of prompts.

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

It gives Codex a staged operating model instead of a one-shot prompt habit.

It turns larger tasks into a loop:

1. bootstrap context
2. sharpen the problem
3. plan execution
4. implement with repo-local agents
5. gate with structured review
6. verify at runtime
7. update release notes and docs
8. write a retro

It also includes a lightweight mode for small tasks so you do not pay the full process cost every time.

## Who This Is For

This is for you if:

- you use Codex on real repos, not just toy prompts
- you want planning, review, QA, and documentation to compound instead of resetting every session
- you want repo-local working memory in `.codex/context/`
- you want small tasks to stay fast while bigger tasks become more reliable

This is probably not for you if every task is a tiny one-file edit and you do not want any persistent workflow artifacts.

## The Core Idea

Most AI coding setups fail the same way: every turn tries to reconstruct the whole task from scratch.

Codex Factory Kit fixes that by adding durable artifacts inside each repo:

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`

That gives you:

- better multi-session continuity
- cleaner handoffs between main agent and subagents
- explicit review and QA evidence
- less repeated explanation

## What The Workflow Looks Like

```text
Vague task
  -> office-hours-codex
  -> PRODUCT.md
  -> sprint-conductor
  -> PLAN.md + TESTPLAN.md
  -> implementation
  -> review-gate
  -> qa-runtime
  -> document-release
  -> retro
```

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

## Quick Start

1. Install the kit:

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh
```

2. Optionally adopt the suggested global policy:

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

3. In a repo you care about, initialize local working memory:

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
printf '\n.codex/context/\n' >> .gitignore
```

4. Use the lightweight loop for small tasks and the full loop for risky or multi-step tasks.

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

## Example Task Flow

Example: you ask Codex to fix a flaky checkout route.

Without a workflow layer:

- the agent may patch code immediately
- tests and runtime verification may be implicit or skipped
- next session has to reconstruct what changed and what remains risky

With Codex Factory Kit:

1. `sprint-conductor` writes a concrete `PLAN.md`
2. `review-gate` records findings into `REVIEW.jsonl`
3. `qa-runtime` records actual verification evidence in `TESTPLAN.md`
4. `document-release` updates release notes if behavior changed
5. `retro` captures what slowed the work down

For more concrete examples, see [docs/examples.md](docs/examples.md).

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

## Repo-Local Agents

This repo does not ship your repo-specific specialist packs.

The intended model is:

- keep shared workflow skills global in `~/.codex/skills/`
- keep project-specific agents in `<repo>/.codex/agents/`
- keep working memory in `<repo>/.codex/context/`

That separation lets you publish the reusable operating model without leaking private project context.

## Public-Friendly By Design

This repository intentionally excludes:

- private project prompts
- repo-local domain agent packs
- personal logs, sessions, auth, or Codex state
- any app-specific code from your private repos

It is the reusable layer only.

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
├── docs/
│   ├── adoption.md
│   ├── examples.md
│   └── share.md
└── templates/
    └── factory/
```

## Docs

- [Adoption notes](docs/adoption.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
