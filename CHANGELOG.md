# Changelog

## Unreleased

### Added

- `factory-router` as the first shipped vNext capability, with integrated model-fit routing guidance
- `factory-kit-upgrade` as the first shipped upgrade-system foundation for local install detection and local refresh into `CODEX_HOME`
- `factory-kit-upgrade check-updates` as the first shipped release-check layer against the latest published GitHub release

### Changed

- `PLAN.md` and `TESTPLAN.md` templates now include a `Routing Snapshot`
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
