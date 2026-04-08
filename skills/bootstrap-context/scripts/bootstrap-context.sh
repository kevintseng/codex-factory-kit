#!/usr/bin/env bash

set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
REPO_PATH="."

usage() {
  cat <<'EOF'
Usage: bootstrap-context.sh [--repo PATH] [--codex-home PATH]

Create any missing Codex Factory Kit context files for a target repository.
This command does not overwrite existing repo-local artifacts.
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --repo)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        REPO_PATH="$2"
        shift 2
        ;;
      --codex-home)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        CODEX_HOME="$2"
        shift 2
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

require_template() {
  local path="$1"

  if [ ! -f "$path" ]; then
    printf 'Missing template: %s\n' "$path" >&2
    printf 'Install Codex Factory Kit first so the global templates exist.\n' >&2
    exit 1
  fi
}

copy_if_missing() {
  local source="$1"
  local target="$2"

  if [ -f "$target" ]; then
    printf 'kept=%s\n' "${target#"$REPO_ROOT/"}"
    return 1
  fi

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
  printf 'created=%s\n' "${target#"$REPO_ROOT/"}"
  return 0
}

touch_if_missing() {
  local target="$1"

  if [ -f "$target" ]; then
    printf 'kept=%s\n' "${target#"$REPO_ROOT/"}"
    return 1
  fi

  mkdir -p "$(dirname "$target")"
  : > "$target"
  printf 'created=%s\n' "${target#"$REPO_ROOT/"}"
  return 0
}

ensure_gitignore_entry() {
  local gitignore_path="$1"

  if [ -f "$gitignore_path" ]; then
    if grep -qxF '.codex/context/' "$gitignore_path" || grep -qxF '.codex/' "$gitignore_path"; then
      printf 'gitignore=kept\n'
      return 1
    fi

    if [ -s "$gitignore_path" ]; then
      printf '\n' >> "$gitignore_path"
    fi
  fi

  printf '.codex/context/\n' >> "$gitignore_path"
  printf 'gitignore=updated\n'
  return 0
}

parse_args "$@"

if ! git -C "$REPO_PATH" rev-parse --show-toplevel >/dev/null 2>&1; then
  printf 'Target is not a git repository: %s\n' "$REPO_PATH" >&2
  exit 1
fi

REPO_ROOT="$(git -C "$REPO_PATH" rev-parse --show-toplevel)"
TEMPLATES_ROOT="$CODEX_HOME/templates/factory"
CONTEXT_DIR="$REPO_ROOT/.codex/context"
GITIGNORE_PATH="$REPO_ROOT/.gitignore"

require_template "$TEMPLATES_ROOT/PRODUCT.md"
require_template "$TEMPLATES_ROOT/PLAN.md"
require_template "$TEMPLATES_ROOT/TESTPLAN.md"
require_template "$TEMPLATES_ROOT/RELEASE.md"
require_template "$TEMPLATES_ROOT/RETRO.md"

mkdir -p "$CONTEXT_DIR"

changed_any="false"

copy_if_missing "$TEMPLATES_ROOT/PRODUCT.md" "$CONTEXT_DIR/PRODUCT.md" && changed_any="true" || true
copy_if_missing "$TEMPLATES_ROOT/PLAN.md" "$CONTEXT_DIR/PLAN.md" && changed_any="true" || true
copy_if_missing "$TEMPLATES_ROOT/TESTPLAN.md" "$CONTEXT_DIR/TESTPLAN.md" && changed_any="true" || true
copy_if_missing "$TEMPLATES_ROOT/RELEASE.md" "$CONTEXT_DIR/RELEASE.md" && changed_any="true" || true
copy_if_missing "$TEMPLATES_ROOT/RETRO.md" "$CONTEXT_DIR/RETRO.md" && changed_any="true" || true
touch_if_missing "$CONTEXT_DIR/REVIEW.jsonl" && changed_any="true" || true
touch_if_missing "$CONTEXT_DIR/LEARNINGS.jsonl" && changed_any="true" || true
ensure_gitignore_entry "$GITIGNORE_PATH" && changed_any="true" || true

printf 'repo_root=%s\n' "$REPO_ROOT"
printf 'codex_home=%s\n' "$CODEX_HOME"
if [ "$changed_any" = "true" ]; then
  printf 'bootstrap_status=updated\n'
else
  printf 'bootstrap_status=already_initialized\n'
fi
printf 'next_step=Open Codex in this repo and say: Plan this task before coding. Keep the workflow lightweight unless risk justifies more.\n'
