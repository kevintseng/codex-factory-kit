---
name: "learn"
description: "Use when a completed task or retro exposes guidance that should persist across tasks. Promotes reusable learnings into `.codex/context/LEARNINGS.jsonl`, lists them, recommends relevant ones for a new task, and can deactivate stale guidance."
---

# Learn

Use this skill when one-off execution lessons should become reusable workflow guidance.

This skill is for cross-task memory, not for dumping raw chat notes. The goal is to promote stable, operational guidance that future routing, planning, review, or QA work can reuse.

## Artifact Paths

Prefer repo-local artifacts:

- `.codex/context/LEARNINGS.jsonl`
- `.codex/context/RETRO.md`

Template source:

- `$CODEX_HOME/templates/factory/LEARNINGS.jsonl.example`

Script:

- `$CODEX_HOME/skills/learn/scripts/factory-kit-learn.py`

## What Belongs In The Store

Good learnings are:

- reusable across more than one task
- specific enough to change future workflow decisions
- grounded in actual outcomes, review findings, QA evidence, or release pain

Examples:

- a task class usually needs browser QA
- a certain pattern repeatedly regresses on lighter execution paths
- release-impacting work usually needs docs and changelog updates
- a risky file area should default to freeze / guard

Do not promote:

- emotional summaries
- one-time project trivia
- vague statements like "be careful"
- guidance that silently rewrites repo-owned policy

## Workflow

1. Read the available repo-local truth:
   - `RETRO.md`
   - `REVIEW.jsonl`
   - `TESTPLAN.md`
   - `RELEASE.md`
2. Decide whether a lesson is truly reusable across future tasks.
3. Promote only the reusable guidance into `.codex/context/LEARNINGS.jsonl`.
4. When starting later work, query the store for relevant learnings before routing or planning.
5. Sync the relevant learnings into `PLAN.md` and `TESTPLAN.md` when they should change execution or verification posture.
6. Deactivate stale learnings when repo reality changes.

## Commands

Capture a manual learning:

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py capture \
  --task-class ui_workflow \
  --kind qa_requirement \
  --summary "Signup funnel edits usually need browser QA." \
  --guidance "Require qa-runtime for signup funnel UI changes." \
  --applies-when "The task changes a browser-facing signup path." \
  --recommended-action "Set needs_qa_runtime=true and verification_level=browser." \
  --tag browser \
  --tag signup \
  --confidence high
```

Promote a learning from the current retro:

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py promote-retro \
  --task-class release_workflow \
  --kind release_ops \
  --summary "Behavior changes usually need docs and changelog updates." \
  --guidance "Run document-release whenever shipped behavior changes." \
  --applies-when "The task changes user-visible behavior or setup." \
  --recommended-action "Set needs_document_release=true before completion." \
  --tag release \
  --tag docs \
  --confidence high
```

Get relevant learnings for a new task:

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py recommend \
  --task-class ui_workflow \
  --tag browser
```

Write the relevant learnings into the current plan artifacts:

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py sync-context \
  --task-class ui_workflow \
  --tag browser
```

Deactivate stale guidance:

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py deactivate \
  --learning-id 20260404-120000-ui_workflow-qa_requirement
```

## Integration Rules

- `factory-router` should consult relevant learnings when `.codex/context/LEARNINGS.jsonl` exists.
- `sprint-conductor` should carry relevant learnings into `PLAN.md` and `TESTPLAN.md` when they materially affect execution or verification.
- `learn sync-context` is the concrete bridge for writing those relevant learnings into the current plan artifacts.
- `retro` captures what happened in one task; `learn` promotes only the reusable guidance.

## Guardrails

- Keep the store explicit, not magical.
- Prefer short stable labels for `task_class`, `kind`, and `tag`.
- Promote only learnings that would change future routing, review, QA, release, or safety behavior.
- Do not silently rewrite `AGENTS.md`, `README.md`, or other hand-authored policy files.
- Deactivate stale learnings instead of leaving contradictory guidance active forever.
