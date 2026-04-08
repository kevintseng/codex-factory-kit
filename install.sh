#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
ADOPT_POLICY="false"
INIT_REPO_SCRIPT="$REPO_ROOT/skills/bootstrap-context/scripts/bootstrap-context.sh"

# shellcheck source=skills/factory-kit-upgrade/scripts/factory-kit-sync-lib.sh
. "$REPO_ROOT/skills/factory-kit-upgrade/scripts/factory-kit-sync-lib.sh"

usage() {
  cat <<'EOF'
Usage: install.sh [--codex-home PATH] [--adopt-policy]

Options:
  --codex-home PATH  Install into a specific CODEX_HOME instead of ~/.codex
  --adopt-policy     Also copy AGENTS.factory-kit.md into AGENTS.md
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --codex-home)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        CODEX_HOME="$2"
        shift 2
        ;;
      --adopt-policy)
        ADOPT_POLICY="true"
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        printf 'Unknown argument: %s\n' "$1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done
}

parse_args "$@"

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
if [ "$ADOPT_POLICY" = "true" ]; then
  cp "$REPO_ROOT/AGENTS.md" "$CODEX_HOME/AGENTS.md"
fi
cp "$INIT_REPO_SCRIPT" "$CODEX_HOME/factory-kit/init-repo.sh"
chmod +x "$CODEX_HOME/factory-kit/init-repo.sh"
cp "$REPO_ROOT/VERSION" "$CODEX_HOME/factory-kit/VERSION"
printf '%s\n' "$REPO_ROOT" > "$CODEX_HOME/factory-kit/SOURCE_REPO"

if [ -f "$REPO_ROOT/CHANGELOG.md" ]; then
  cp "$REPO_ROOT/CHANGELOG.md" "$CODEX_HOME/factory-kit/CHANGELOG.md"
fi

printf '\n'
printf 'Installed skills and templates into %s\n' "$CODEX_HOME"
printf 'Wrote suggested policy to %s/AGENTS.factory-kit.md\n' "$CODEX_HOME"
printf 'Wrote repo bootstrap helper to %s/factory-kit/init-repo.sh\n' "$CODEX_HOME"
if [ "$ADOPT_POLICY" = "true" ]; then
  printf 'Adopted factory policy as %s/AGENTS.md\n' "$CODEX_HOME"
  printf 'Next step: in your project repo, run %s/factory-kit/init-repo.sh\n' "$CODEX_HOME"
  printf 'Then tell Codex: Plan this task before coding. Keep the workflow lightweight unless risk justifies more.\n'
else
  printf 'Your existing %s/AGENTS.md was not modified.\n' "$CODEX_HOME"
  printf 'Re-run with --adopt-policy if you want to activate it automatically.\n'
  printf 'If you want to try the repo setup now, run %s/factory-kit/init-repo.sh from your project repo.\n' "$CODEX_HOME"
fi
printf 'Wrote version metadata to %s/factory-kit/\n' "$CODEX_HOME"
