# Generated Skill Index

> Generated from the shipped skill surface. Reference only; do not hand-edit.

## Bootstrap Context

- Skill name: `bootstrap-context`
- Contract summary: Use when a repo does not yet have `.codex/context/` artifacts and you want to initialize the factory files from the global templates before planning or implementation begins.
- Manifest summary: Initialize .codex/context from the factory templates
- Repo-local artifacts:
  - `.codex/context/PRODUCT.md`
  - `.codex/context/PLAN.md`
  - `.codex/context/TESTPLAN.md`
  - `.codex/context/REVIEW.jsonl`
  - `.codex/context/RELEASE.md`
  - `.codex/context/RETRO.md`
  - `.codex/context/LEARNINGS.jsonl`
- Executables:
  - `skills/bootstrap-context/scripts/bootstrap-context.sh`

## Design Review

- Skill name: `design-review`
- Contract summary: Use when a design or workflow-UX governance lens should review clarity, ergonomics, naming, and user-facing coherence before ship. This is a thin overlay on top of `review-gate`, not a replacement.
- Manifest summary: Apply a design and workflow-UX governance lens on top of review-gate
- Repo-local artifacts:
  - `.codex/context/REVIEW.jsonl`
  - `.codex/context/PLAN.md`
  - `.codex/context/RELEASE.md`
- Executables: none

## Document Release

- Skill name: `document-release`
- Contract summary: Use when shipped behavior, setup, operations, or external contracts changed and docs or release notes may now be stale. Updates `.codex/context/RELEASE.md` and the relevant repo docs.
- Manifest summary: Update release notes and docs after behavior changes
- Repo-local artifacts:
  - `.codex/context/RELEASE.md`
  - `$CODEX_HOME/templates/factory/RELEASE.md`
- Executables: none

## Engineering Review

- Skill name: `eng-review`
- Contract summary: Use when an engineering governance lens should review maintainability, operability, integration quality, and long-term coherence before ship. This is a thin overlay on top of `review-gate`, not a replacement.
- Manifest summary: Apply an engineering leadership governance lens on top of review-gate
- Repo-local artifacts:
  - `.codex/context/REVIEW.jsonl`
  - `.codex/context/PLAN.md`
  - `.codex/context/TESTPLAN.md`
- Executables: none

## Factory Kit Upgrade

- Skill name: `factory-kit-upgrade`
- Contract summary: Use when the installed Codex Factory Kit needs version reporting, a published-release check, or a local upgrade from the current repo checkout into a target `CODEX_HOME`.
- Manifest summary: Inspect, release-check, or refresh a local Codex Factory Kit install from a repo checkout
- Repo-local artifacts: none declared
- Executables:
  - `skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh`

## Factory Router

- Skill name: `factory-router`
- Contract summary: Use when a task needs an explicit route before implementation. Classifies the task into lightweight or full mode, declares required downstream skills, and adds model-fit guidance to the same routing envelope.
- Manifest summary: Classify a task into the right factory route before implementation starts
- Repo-local artifacts: none declared
- Executables: none

## Founder Review

- Skill name: `founder-review`
- Contract summary: Use when a founder or product-owner governance lens should review user value, scope discipline, adoption fit, and messaging before ship. This is a thin overlay on top of `review-gate`, not a replacement.
- Manifest summary: Apply a founder and product-value governance lens on top of review-gate
- Repo-local artifacts:
  - `.codex/context/REVIEW.jsonl`
  - `.codex/context/RELEASE.md` when release framing matters
- Executables: none

## Freeze

- Skill name: `freeze`
- Contract summary: Use when the blast radius should stay deliberately narrow. Creates or refreshes `.codex/context/FREEZE.md` with allowed paths, blocked paths, and protected invariants before implementation continues.
- Manifest summary: Create a narrow-scope freeze contract before risky edits
- Repo-local artifacts:
  - `.codex/context/FREEZE.md`
  - `$CODEX_HOME/templates/factory/FREEZE.md`
- Executables: none

## Guard

- Skill name: `guard`
- Contract summary: Use when a freeze contract exists and you need to verify that the current diff stayed inside the declared boundary. Runs the guard check and reports PASS or FAIL with concrete violations.
- Manifest summary: Check whether the current diff stayed inside a freeze contract
- Repo-local artifacts: none declared
- Executables: none

## Learn

- Skill name: `learn`
- Contract summary: Use when a completed task or retro exposes guidance that should persist across tasks. Promotes reusable learnings into `.codex/context/LEARNINGS.jsonl`, recommends relevant guidance for a new task, syncs it into current planning artifacts, and can deactivate stale entries.
- Manifest summary: Promote reusable workflow learnings into repo-local memory and sync relevant guidance into planning artifacts
- Repo-local artifacts:
  - `.codex/context/LEARNINGS.jsonl`
  - `.codex/context/RETRO.md`
  - `$CODEX_HOME/templates/factory/LEARNINGS.jsonl.example`
  - `$CODEX_HOME/skills/learn/scripts/factory-kit-learn.py`
- Executables:
  - `skills/learn/scripts/factory-kit-learn.py`

## Office Hours Codex

- Skill name: `office-hours-codex`
- Contract summary: Use when a request is still vague or product-shaped and needs reframing into a sharper problem statement, narrow wedge, constraints, and success criteria before implementation. Writes or refreshes `.codex/context/PRODUCT.md` using the global factory template.
- Manifest summary: Turn vague product asks into a sharp build brief
- Repo-local artifacts:
  - `.codex/context/PRODUCT.md`
  - `$CODEX_HOME/templates/factory/PRODUCT.md`
- Executables: none

## QA Runtime

- Skill name: `qa-runtime`
- Contract summary: Use when a browser flow, route, UI, or end-to-end workflow needs runtime verification. Uses the existing Playwright skills and records concrete checks in `.codex/context/TESTPLAN.md`.
- Manifest summary: Run targeted runtime QA and record evidence
- Repo-local artifacts:
  - `.codex/context/TESTPLAN.md`
  - `$CODEX_HOME/templates/factory/TESTPLAN.md`
- Executables: none

## Release Review

- Skill name: `release-review`
- Contract summary: Use when a release-readiness governance lens should review versioning, changelog accuracy, rollout safety, upgrade impact, and release-note honesty before ship. This is a thin overlay on top of `review-gate`, not a replacement.
- Manifest summary: Apply a release-readiness governance lens on top of review-gate
- Repo-local artifacts:
  - `.codex/context/REVIEW.jsonl`
  - `.codex/context/RELEASE.md`
  - `CHANGELOG.md`
  - `VERSION`
- Executables: none

## Retro

- Skill name: `retro`
- Contract summary: Use after a ship, major workflow step, or completed task to write or refresh `.codex/context/RETRO.md` with what shipped, what broke, what slowed the work down, and what tooling or agent gaps were exposed.
- Manifest summary: Capture what shipped, what hurt, and what to improve
- Repo-local artifacts:
  - `.codex/context/RETRO.md`
  - `$CODEX_HOME/templates/factory/RETRO.md`
- Executables: none

## Review Gate

- Skill name: `review-gate`
- Contract summary: Use when code or configuration is ready for a serious gate before merge or ship. Writes or appends `.codex/context/REVIEW.jsonl`, runs repo-local review agents, and emits a clear pass/fail status.
- Manifest summary: Gate work with structured findings and pass/fail status
- Repo-local artifacts:
  - `.codex/context/REVIEW.jsonl`
  - `$CODEX_HOME/templates/factory/REVIEW.jsonl.example`
- Executables: none

## Security Review

- Skill name: `security-review`
- Contract summary: Use when a security governance lens should review trust boundaries, secrets handling, mutation safety, and abuse surface before ship. This is a thin overlay on top of `review-gate`, not a replacement.
- Manifest summary: Apply a security and trust-boundary governance lens on top of review-gate
- Repo-local artifacts:
  - `.codex/context/REVIEW.jsonl`
  - `.codex/context/TESTPLAN.md`
  - `.codex/context/FREEZE.md` when the scope was deliberately narrowed
- Executables: none

## Sprint Conductor

- Skill name: `sprint-conductor`
- Contract summary: Use when work needs staged execution instead of a single freeform prompt. Builds or refreshes `.codex/context/PLAN.md` and `.codex/context/TESTPLAN.md`, maps local work vs delegated work, and routes to the right repo-local agents.
- Manifest summary: Turn a task into a staged Codex execution plan
- Repo-local artifacts:
  - `.codex/context/PLAN.md`
  - `.codex/context/TESTPLAN.md`
  - `$CODEX_HOME/templates/factory/PLAN.md`
  - `$CODEX_HOME/templates/factory/TESTPLAN.md`
- Executables: none
