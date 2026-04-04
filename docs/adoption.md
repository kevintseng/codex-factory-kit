# Adoption Notes

## Safe First Step

Start by installing the skills and templates without changing your global policy:

```bash
./install.sh
```

Then read:

- `~/.codex/AGENTS.factory-kit.md`

Merge that into `~/.codex/AGENTS.md` only if you want the factory loop to become the default.

If you want to verify what is installed later, use:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

## Recommended Repo Setup

For repos where you want persistent working memory:

1. create `.codex/context/`
2. seed it from the factory templates
3. add `.codex/context/` to `.gitignore`
4. start non-trivial tasks with `factory-router` when you want explicit route and model-fit guidance
5. keep `.codex/context/LEARNINGS.jsonl` local and use `learn` only for reusable cross-task guidance

## Recommended Rollout

Do not force this on every repo immediately.

A better order is:

1. one active product repo
2. one infrastructure or backend repo
3. one UI-heavy repo where `qa-runtime` is useful

## Where It Helps Most

- repos where users want a recommended route before implementation starts
- multi-step tasks
- code review and ship gates
- browser QA
- AI-heavy or domain-heavy repos
- cases where work spans multiple sessions

## Where To Stay Lightweight

- tiny one-file fixes
- quick local refactors
- chores where runtime verification is unnecessary

## New Default Recommendation

For non-trivial work, the best entry point is now:

1. `bootstrap-context` if the repo still lacks `.codex/context/`
2. `factory-router` to decide lightweight versus full mode and the required gates
3. `office-hours-codex` only if the ask is still vague
4. `freeze` when the blast radius should stay deliberately narrow
5. `sprint-conductor` to turn the chosen route into `PLAN.md` and `TESTPLAN.md`
6. `learn` after `retro` when the repo exposed reusable workflow guidance

If the work is risky but intentionally narrow, add `.codex/context/FREEZE.md` before implementation and run `guard` before the final review gate.

## Upgrade Recommendation

When the repo checkout has moved forward and you want your installed kit to catch up:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

This refreshes the selected `CODEX_HOME` from the current repo checkout. It does not overwrite repo-local `.codex/context/` artifacts or your existing `~/.codex/AGENTS.md`.

If you run the installed upgrade script from outside the source checkout, it can reuse the stored source path from install metadata. If that source path is no longer valid, pass `--source-repo /path/to/codex-factory-kit` explicitly.

If you only want to know whether a newer published release exists, use `check-updates`. It compares your local state against the configured GitHub release authority and writes the result to `~/.codex/factory-kit/update-state.json`.

## Learning Recommendation

Do not treat every retro point as durable memory.

Use `learn` only when the lesson should affect future routing, review, QA, release, or safety behavior. Keep the durable store repo-local in `.codex/context/LEARNINGS.jsonl`, use `learn sync-context` to write relevant guidance into `PLAN.md` and `TESTPLAN.md`, and deactivate stale guidance instead of silently rewriting policy files.
