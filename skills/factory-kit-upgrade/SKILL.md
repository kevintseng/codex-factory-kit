---
name: "factory-kit-upgrade"
description: "Use when the installed Codex Factory Kit needs version reporting, a published-release check, or a local upgrade from the current repo checkout into a target `CODEX_HOME`."
---

# Factory Kit Upgrade

Use this skill when you need to inspect the installed Factory Kit version, compare it with the latest published release, detect the target install root, or refresh the installed pack from the current repo checkout.

This is the first shipped upgrade-system foundation. It is intentionally local and explicit.

## What It Does Today

- reads the repo `VERSION`
- reads installed metadata under `CODEX_HOME/factory-kit/`
- reuses the stored source checkout path from install metadata when available
- reports the detected source and target install roots
- checks the latest published release from the configured GitHub release authority
- writes release-check state under `CODEX_HOME/factory-kit/update-state.json`
- compares the repo checkout version with the installed version
- upgrades the selected `CODEX_HOME` from the current repo checkout

## What It Does Not Do Yet

- fetch published GitHub releases
- auto-check remote updates on its own
- mutate vendored repo installs automatically
- rewrite repo-local `.codex/context/` artifacts
- rewrite a user's `~/.codex/AGENTS.md`

## Required Inputs

- a target `CODEX_HOME`, or accept the default `~/.codex`
- a source repo checkout, or install metadata that still points to a valid checkout

## Workflow

1. Run the bundled script with `status` to inspect the source repo version and installed target version.
2. Run `check-updates` when you want to compare the local state against the latest published release.
3. Confirm the detected target install root.
4. If the target should be refreshed from the current checkout, run `upgrade`.
5. Re-check `status` or `check-updates` after the upgrade.
6. Update any release-facing notes if the shipped contract changed.

## Commands

From the repo root:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

Against a different Codex home:

```bash
CODEX_HOME=/tmp/codex-home ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
CODEX_HOME=/tmp/codex-home ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
CODEX_HOME=/tmp/codex-home ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

Explicit source repo:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status --source-repo /path/to/codex-factory-kit
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates --source-repo /path/to/codex-factory-kit
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade --source-repo /path/to/codex-factory-kit
```

## Output Expectations

`status` should report:

- source repo path
- source version
- target `CODEX_HOME`
- detected install root
- installed version if present
- `version_relation`: `install | upgrade | current | downgrade | unknown`
- whether an update is available from the current repo checkout

`check-updates` should report:

- release authority repo
- check timestamp
- latest release tag and version
- latest release URL and publish time
- source and installed versions
- `source_release_relation`: `ahead | current | behind | unknown`
- `installed_release_relation`: `ahead | current | behind | not_installed | unknown`
- whether an update is available from the published release authority
- `update_state_path`

`upgrade` should report:

- source repo path
- target `CODEX_HOME`
- files refreshed
- version relation before the refresh
- resulting installed version

If the source checkout is older than the installed version, `upgrade` should refuse by default and require:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade --allow-downgrade
```

## Guardrails

- never overwrite `~/.codex/AGENTS.md`
- never touch repo-local `.codex/context/`
- never mutate an install root other than the one reported
- never downgrade an installed kit silently
- never claim a published update exists without naming the release authority and latest version
- fail clearly if the source repo checkout is incomplete
