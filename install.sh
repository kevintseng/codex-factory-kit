#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

# shellcheck source=skills/factory-kit-upgrade/scripts/factory-kit-sync-lib.sh
. "$REPO_ROOT/skills/factory-kit-upgrade/scripts/factory-kit-sync-lib.sh"

mkdir -p "$CODEX_HOME/skills"
mkdir -p "$CODEX_HOME/templates/factory"
mkdir -p "$CODEX_HOME/factory-kit"
sync_skill_surface \
  "$REPO_ROOT/skills" \
  "$CODEX_HOME/skills" \
  "$CODEX_HOME/factory-kit/INSTALLED_SKILLS" \
  "installed_skill"

sync_template_surface \
  "$REPO_ROOT/templates/factory" \
  "$CODEX_HOME/templates/factory" \
  "$CODEX_HOME/factory-kit/INSTALLED_TEMPLATES"

cp "$REPO_ROOT/AGENTS.md" "$CODEX_HOME/AGENTS.factory-kit.md"
cp "$REPO_ROOT/VERSION" "$CODEX_HOME/factory-kit/VERSION"
printf '%s\n' "$REPO_ROOT" > "$CODEX_HOME/factory-kit/SOURCE_REPO"

if [ -f "$REPO_ROOT/CHANGELOG.md" ]; then
  cp "$REPO_ROOT/CHANGELOG.md" "$CODEX_HOME/factory-kit/CHANGELOG.md"
fi

printf '\n'
printf 'Installed skills and templates into %s\n' "$CODEX_HOME"
printf 'Wrote suggested policy to %s/AGENTS.factory-kit.md\n' "$CODEX_HOME"
printf 'Wrote version metadata to %s/factory-kit/\n' "$CODEX_HOME"
printf 'Your existing %s/AGENTS.md was not modified.\n' "$CODEX_HOME"
