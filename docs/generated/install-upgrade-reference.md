# Generated Install And Upgrade Reference

> Generated from `install.sh`, the shipped skill surface, and `factory-kit-upgrade`. Reference only; do not hand-edit.

## Install Targets

- `~/.codex/skills/<skill>/` for each shipped skill
- `~/.codex/templates/factory/*` for shipped templates
- `~/.codex/AGENTS.factory-kit.md` for the suggested global policy
- `~/.codex/factory-kit/VERSION`
- `~/.codex/factory-kit/CHANGELOG.md`
- `~/.codex/factory-kit/SOURCE_REPO`
- `~/.codex/factory-kit/update-state.json` after `check-updates` runs

## Installed Skills

- `bootstrap-context`
- `document-release`
- `factory-kit-upgrade`
- `factory-router`
- `freeze`
- `guard`
- `learn`
- `office-hours-codex`
- `qa-runtime`
- `retro`
- `review-gate`
- `sprint-conductor`

## Installed Templates

- `FREEZE.md`
- `LEARNINGS.jsonl.example`
- `PLAN.md`
- `PRODUCT.md`
- `RELEASE.md`
- `RETRO.md`
- `REVIEW.jsonl.example`
- `TESTPLAN.md`

## Upgrade Commands

```text
Usage:
  factory-kit-upgrade.sh status [--source-repo PATH] [--codex-home PATH]
  factory-kit-upgrade.sh check-updates [--source-repo PATH] [--codex-home PATH] [--release-repo OWNER/REPO]
  factory-kit-upgrade.sh upgrade [--source-repo PATH] [--codex-home PATH]

Commands:
  status         Print source and installed version information
  check-updates  Compare local versions against the latest published release
  upgrade        Refresh the selected CODEX_HOME from the source repo checkout
```

## Safety Contract

- The installer does not overwrite `~/.codex/AGENTS.md`.
- `factory-kit-upgrade upgrade` refreshes only the selected `CODEX_HOME` root.
- Human-owned repo files are not rewritten by generated references.
