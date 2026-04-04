#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p "$CODEX_HOME/skills"
mkdir -p "$CODEX_HOME/templates/factory"
mkdir -p "$CODEX_HOME/factory-kit"

copy_tree() {
  local src="$1"
  local dst="$2"

  mkdir -p "$dst"
  cp -R "$src"/. "$dst"/
}

for skill_dir in "$REPO_ROOT"/skills/*; do
  skill_name="$(basename "$skill_dir")"
  rm -rf "$CODEX_HOME/skills/$skill_name"
  copy_tree "$skill_dir" "$CODEX_HOME/skills/$skill_name"
  printf 'installed skill: %s\n' "$skill_name"
done

copy_tree "$REPO_ROOT/templates/factory" "$CODEX_HOME/templates/factory"
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
