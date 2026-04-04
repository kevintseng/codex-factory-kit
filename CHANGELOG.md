# Changelog

## Unreleased

### Fixed

- installer and local upgrade flows now prune only retired factory-kit-owned skills and templates while preserving unrelated user-owned items under `~/.codex`
- local Playwright QA artifacts are now ignored by default so routine browser verification does not pollute `git status`

## 0.2.1 - 2026-04-04

### Fixed

- `learn` now accepts `--context-dir` before or after the subcommand, so installed dogfood flows no longer fail on a common argument order

## 0.2.0 - 2026-04-04

### Added

- `factory-router` as the first shipped vNext capability, with integrated model-fit routing guidance
- `factory-kit-upgrade` as the first shipped upgrade-system foundation for local install detection and local refresh into `CODEX_HOME`
- `factory-kit-upgrade check-updates` as the first shipped release-check layer against the latest published GitHub release
- `learn` as the first shipped learning layer with repo-local `LEARNINGS.jsonl`, retro promotion workflow, and durable recommendation/deactivation commands
- `learn sync-context` to write relevant guidance into `PLAN.md` and `TESTPLAN.md`
- generated contract references for the skill index, capability matrix, AGENTS routing snippet, and install/upgrade contract
- `scripts/generate-factory-contracts.py` plus `scripts/test-generated-contracts.sh`
- governance role packs: `founder-review`, `eng-review`, `design-review`, `security-review`, and `release-review`

### Changed

- `PLAN.md` and `TESTPLAN.md` templates now include a `Routing Snapshot`
- `PLAN.md` and the factory workflow now carry relevant learnings when reusable guidance exists
- `PLAN.md` and `TESTPLAN.md` now include a concrete `Relevant Learnings` section for learning integration
- review policy now treats governance overlays as thin layers on top of `review-gate`, not replacements
- installed metadata now includes `VERSION` and `CHANGELOG.md` under `~/.codex/factory-kit/`
- installed metadata now records the source checkout path for safer local refreshes
- `factory-kit-upgrade` now refuses downgrades by default and reports version relation explicitly
- `factory-kit-upgrade` now writes `update-state.json` after release checks

## 0.1.1

### Changed

- Added concrete demo and platform share copy
- Improved public-facing documentation around adoption and examples

## 0.1.0

### Added

- Initial public release of Codex Factory Kit

### Changed

- Polished public docs and sharing assets
