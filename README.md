# Codex Factory Kit

Codex Factory Kit is a Codex-native workflow layer for people who want more than a loose collection of prompts.

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

It gives Codex a staged operating model instead of a one-shot prompt habit, and now includes a first-class router for choosing the right path before implementation begins, a safety layer for keeping risky edits inside a narrow boundary, and a learning layer for promoting reusable workflow guidance across tasks.

It turns larger tasks into a loop:

1. bootstrap context
2. route the task
3. sharpen the problem if needed
4. plan execution
5. optionally freeze scope for risky narrow changes
6. implement with repo-local agents
7. guard the diff against the frozen boundary
8. gate with structured review
9. verify at runtime
10. update release notes and docs
11. write a retro
12. promote reusable learnings when the lesson should persist

It also includes a lightweight mode for small tasks so you do not pay the full process cost every time, plus model-fit guidance so planning and gates can stay stronger than bounded worker execution.

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
- `LEARNINGS.jsonl` for reusable cross-task guidance
- `FREEZE.md` when you need to scope-lock a risky change

That gives you:

- better multi-session continuity
- cleaner handoffs between main agent and subagents
- explicit review and QA evidence
- less repeated explanation

## What The Workflow Looks Like

```text
Vague task
  -> factory-router
  -> office-hours-codex
  -> PRODUCT.md
  -> sprint-conductor
  -> PLAN.md + TESTPLAN.md
  -> optional freeze
  -> implementation
  -> optional guard
  -> review-gate
  -> qa-runtime
  -> document-release
  -> retro
  -> optional learn
```

## What Is Included

- global skills for Codex:
  - `bootstrap-context`
  - `factory-router`
  - `factory-kit-upgrade`
  - `freeze`
  - `guard`
  - `learn`
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
  - `LEARNINGS.jsonl.example`
  - `FREEZE.md`
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
- `LEARNINGS.jsonl`

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
- `VERSION` and `CHANGELOG.md` into `~/.codex/factory-kit/`

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

For non-trivial work, start with `factory-router` when you want the kit to classify:

- lightweight mode or full mode
- required follow-up skills
- model-fit expectations for lead and worker execution
- whether `freeze` / `guard` should be used to keep the blast radius narrow

To inspect the installed version or refresh your local install from this repo checkout:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

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
: > .codex/context/LEARNINGS.jsonl
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
6. `learn` promotes the reusable lessons into `LEARNINGS.jsonl`
7. on the next similar task, `learn sync-context` writes the relevant guidance back into `PLAN.md` and `TESTPLAN.md`

For more concrete examples, see [docs/examples.md](docs/examples.md).
For a more realistic before/after artifact walkthrough, see [docs/demo.md](docs/demo.md).

## Factory Router

`factory-router` is the first vNext capability that is shipped in the public kit.

Its job is to classify a task before implementation begins:

- lightweight mode or full mode
- whether `office-hours-codex`, `review-gate`, `qa-runtime`, `document-release`, and `retro` are required
- whether `freeze` and `guard` should be used to scope-lock risky work
- whether the work should stay local or can be split into bounded parallel slices
- which model class should lead the task and which class can safely execute bounded work

This is soft orchestration, not hidden automation. The router helps Codex choose the right workflow and quality bar; it does not claim platform-level interception or destructive auto-execution.

## Freeze And Guard

The kit now ships a basic safety layer:

- `freeze` creates `.codex/context/FREEZE.md` with allowed paths, blocked paths, and protected invariants
- `guard` checks the current diff against that freeze contract before the final gate

This is for risky narrow-scope work in large repos, not for every tiny edit. The goal is to make blast-radius control explicit and checkable.

## Learning Layer

The kit now ships a first learning layer:

- `learn` promotes reusable guidance into `.codex/context/LEARNINGS.jsonl`
- the learning store is repo-local and durable across tasks
- learnings can be listed, recommended for a new task, synced into plan artifacts, and deactivated when stale

This is not a freeform memory dump. It is for guidance that should change future routing, review, QA, release, or safety behavior.

When a new task matches prior guidance, use:

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py sync-context \
  --task-class ui_workflow \
  --tag browser
```

This refreshes the `Relevant Learnings` section in `.codex/context/PLAN.md` and `.codex/context/TESTPLAN.md`.

## Versioning, Release Checks, And Upgrade

The kit now ships a local upgrade foundation plus a first release-check layer:

- top-level `VERSION`
- top-level `CHANGELOG.md`
- installed metadata under `~/.codex/factory-kit/`
- `factory-kit-upgrade` for status, release checks, and local refresh from a repo checkout

What it does today:

- report the repo version and installed version
- compare local versions against the latest published GitHub release
- persist update-check state in `~/.codex/factory-kit/update-state.json`
- detect the selected `CODEX_HOME`
- reuse the stored source checkout path from install metadata when available
- refresh the installed skill pack and templates from the current repo checkout

What it does not do yet:

- auto-upgrade without an explicit command
- proactively prompt or snooze update checks
- rewrite repo-local `.codex/context/` artifacts
- overwrite `~/.codex/AGENTS.md`

Use `check-updates` when you want the latest published release check without changing the install:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

If the current repo checkout is older than the installed version, `upgrade` refuses by default and requires `--allow-downgrade`.

## Default Loop

Use the full loop when the task is multi-step, risky, or touches multiple surfaces:

1. `bootstrap-context`
2. `factory-router` when the route is not already obvious
3. `office-hours-codex` for vague asks
4. `freeze` when the blast radius should stay narrow
5. `sprint-conductor`
6. implementation with repo-local agents
7. `guard` when a freeze contract exists
8. `review-gate`
9. `qa-runtime`
10. `document-release`
11. `retro`

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
├── VERSION
├── CHANGELOG.md
├── AGENTS.md
├── install.sh
├── skills/
│   ├── bootstrap-context/
│   ├── factory-router/
│   ├── factory-kit-upgrade/
│   ├── freeze/
│   ├── guard/
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
        └── FREEZE.md
```

## Docs

- [Adoption notes](docs/adoption.md)
- [Concrete demo](docs/demo.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
