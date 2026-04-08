# Codex Factory Kit

Codex Factory Kit is a workflow pack for Codex users who work in real repositories and want something more repeatable than "paste a prompt and hope the session remembers everything."

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

It installs a set of skills, templates, and a suggested `AGENTS.md` policy into `~/.codex/` so Codex can plan work, keep repo-local context, gate risky changes, and leave behind reusable artifacts.

If you only need tiny one-off edits, this kit is probably too much process. If you regularly do multi-step tasks, code review, browser QA, or multi-session work, this kit can help.

## The 30-Second Answer

- What it is:
  A Codex workflow kit. It is not an app, daemon, framework, or IDE plugin.
- What it installs:
  Skills in `~/.codex/skills/`, templates in `~/.codex/templates/factory/`, and a suggested policy file at `~/.codex/AGENTS.factory-kit.md`.
- What problem it solves:
  Codex sessions tend to lose task context, skip planning, and leave weak evidence for review and QA. This kit gives Codex a structured way to leave behind repo-local working memory.
- What you get in practice:
  Codex can write or refresh `PLAN.md`, `TESTPLAN.md`, `REVIEW.jsonl`, `RELEASE.md`, `RETRO.md`, and `LEARNINGS.jsonl` inside a repo's `.codex/context/`.

## Beginner Onboarding (Copy/Paste)

For a non-technical first run, do only this:

```bash
cd /path/to/codex-factory-kit
./quickstart.sh --repo /path/to/your/repo
```

That command:

1. Installs the kit (if not installed).
2. Initializes the repo context.
3. Prints the ready-to-say sentence for Codex.

If you are inside the repo already, use:

```bash
cd /path/to/your/repo
/path/to/codex-factory-kit/quickstart.sh
```

If you want the factory policy active immediately, add `--adopt-policy`:

```bash
./quickstart.sh --repo /path/to/your/repo --adopt-policy
```

If the kit is already installed and you only need bootstrap, use `--skip-install`.

```bash
./quickstart.sh --repo /path/to/your/repo --skip-install
```

Quick flag meaning:

- `--repo PATH` = target repo is the command argument.
- no `--repo` = target repo is the folder where you run the command.
- `--adopt-policy` = write recommended policy to `~/.codex/AGENTS.md` now.
- no `--adopt-policy` = keep your existing `~/.codex/AGENTS.md` unchanged.

## You Do Not Need To Learn The Internal Files First

You do not need to understand `.codex/context/`, hidden folders, `AGENTS.md`, or `gitignore` before trying this.

The intended first-run path is:

1. install the kit
2. optionally activate the suggested policy
3. run one repo bootstrap command
4. tell Codex to plan before coding

## When To Use It

This kit is useful when:

- you use Codex on real repos, not toy prompts
- you want a recommended route before implementation starts
- you want planning, review, QA, and documentation to compound instead of resetting every session
- you want risky work to have clearer gates and narrower boundaries
- you expect work to span multiple sessions

This kit is probably not worth it when:

- every task is a tiny one-file edit
- you do not want persistent workflow artifacts in the repo
- you just want Codex to make a quick patch and leave

## What It Actually Changes

Without this kit, a lot of Codex work stays implicit:

- what the task scope was
- what got verified
- what review found
- what should be remembered next time

With this kit, Codex can turn that into explicit repo-local artifacts:

- `PRODUCT.md` for a sharper brief when the ask is vague
- `PLAN.md` for the execution plan
- `TESTPLAN.md` for verification scope and evidence
- `REVIEW.jsonl` for review findings and gate status
- `RELEASE.md` for behavior or setup changes
- `RETRO.md` for what slowed the work down
- `LEARNINGS.jsonl` for reusable guidance across future tasks
- `FREEZE.md` when a risky change needs a narrow edit boundary

## Choose One Install Path

Clone this repo somewhere local, then choose one of these:

- Safe install only:

```bash
./install.sh
```

- Install and activate the suggested policy now:

```bash
./install.sh --adopt-policy
```

Both commands install:

- `skills/*` into `~/.codex/skills/`
- `templates/factory/*` into `~/.codex/templates/factory/`
- `AGENTS.md` into `~/.codex/AGENTS.factory-kit.md`
- `VERSION` and `CHANGELOG.md` into `~/.codex/factory-kit/`

The safe path does not overwrite your existing `~/.codex/AGENTS.md`.
The activated path copies the suggested policy into `~/.codex/AGENTS.md` for you and becomes the default Codex policy.

Flag behavior in one line:

- `./install.sh` installs the kit only, and leaves your current `~/.codex/AGENTS.md` untouched.
- `./install.sh --adopt-policy` installs and activates the suggested policy at `~/.codex/AGENTS.md` immediately.

If you want to confirm what is installed later, run:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

## 3-Minute Setup

1. Install the kit:

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh --adopt-policy
```

If you prefer to review the policy before activating it, use `./install.sh` instead.

2. Go to the repo where you want to use Codex Factory Kit and run:

```bash
~/.codex/factory-kit/init-repo.sh
```

That creates any missing context files and updates `.gitignore` for you.

If your repo is not your current directory, run `~/.codex/factory-kit/init-repo.sh --repo /path/to/repo`.

For the bootstrap helper:

- No `--repo` means: initialize your current directory.
- `--repo /path/to/repo` means: initialize that exact path (useful when running from another folder).

3. Open Codex in that repo and start with:

```text
Plan this task before coding. Keep the workflow lightweight unless risk justifies more.
```

4. If the task changes a user flow, ask Codex to verify it before finishing:

```text
This changes a browser or runtime flow. Verify it before we call it done.
```

If you are new to this kit, stop here for day one. Install it, bootstrap the repo, and tell Codex to plan first. You do not need the advanced sections below until the work gets bigger or riskier.

## Minimal Daily Use

For a small task:

1. Ask Codex to plan before coding.
2. Let it refresh the repo plan.
3. Implement the change.
4. Skip the rest unless risk rises.

For a bigger or riskier task:

1. bootstrap the repo if you have not done it yet
2. ask Codex to classify the task before implementation
3. ask for planning if the task is still vague
4. let Codex write the plan and test plan
5. optionally lock the scope before risky narrow-scope work
6. implementation
7. optional scope check
8. structured review
9. runtime or browser verification when evidence matters
10. docs or release updates if behavior or setup changed
11. retro
12. optional reusable learning capture

Advanced mapping:

- classify the task: `factory-router`
- write the plan: `sprint-conductor`
- structured review: `review-gate`
- runtime verification: `qa-runtime`

## What Is Included

- global skills for Codex:
  - `bootstrap-context`
  - `factory-router`
  - `factory-kit-upgrade`
  - `freeze`
  - `guard`
  - `founder-review`
  - `eng-review`
  - `design-review`
  - `security-review`
  - `release-review`
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
- generated contract references under `docs/generated/`

## Why The Workflow Exists

The main idea is simple: persistent artifacts beat re-explaining the task every turn.

Instead of asking Codex to hold the whole project in short-term context every time, keep working artifacts in `.codex/context/` inside each repo. That makes handoffs, review, QA, and follow-up work materially more stable.

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

## Per-Repo Adoption

Default path:

```bash
~/.codex/factory-kit/init-repo.sh
```

This creates any missing repo-local artifacts without overwriting existing ones.

Advanced manual fallback:

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

## Governance Role Packs

The kit now ships thin governance overlays on top of `review-gate`:

- `founder-review`
- `eng-review`
- `design-review`
- `security-review`
- `release-review`

These are not replacement workflows. They are optional review lenses for different kinds of ship decisions.

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
- refresh the installed factory-kit-owned skill pack and templates from the current repo checkout
- prune retired factory-kit-owned skills and templates while leaving unrelated user-owned items in place

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
