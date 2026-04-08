#!/usr/bin/env bash

set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="."
ADOPT_POLICY="false"
SKIP_INSTALL="false"

usage() {
  cat <<'EOF'
Usage: quickstart.sh [--repo PATH] [--codex-home PATH] [--adopt-policy] [--skip-install]

Default workflow:
1) run install.sh (unless --skip-install)
2) run init-repo.sh for the target repository

Options:
  --repo PATH       Bootstrap this repo path (defaults to current directory)
  --codex-home PATH Install/use this CODEX_HOME
  --adopt-policy    Copy AGENTS.factory-kit.md into AGENTS.md during install
  --skip-install    Skip install step and only run init-repo.sh
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
      --adopt-policy)
        ADOPT_POLICY="true"
        shift
        ;;
      --skip-install)
        SKIP_INSTALL="true"
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

require_git_repo() {
  if ! git -C "$REPO_PATH" rev-parse --show-toplevel >/dev/null 2>&1; then
    printf 'Target is not a git repository: %s\n' "$REPO_PATH" >&2
    printf 'Please run this command in the target repo, or pass --repo with a git repository path.\n' >&2
    exit 1
  fi
}

install_kit() {
  local install_cmd=("$KIT_ROOT/install.sh" --codex-home "$CODEX_HOME")
  if [ "$ADOPT_POLICY" = "true" ]; then
    install_cmd+=(--adopt-policy)
  fi
  "${install_cmd[@]}"
}

bootstrap_repo() {
  local init_script="$CODEX_HOME/factory-kit/init-repo.sh"

  if [ ! -x "$init_script" ]; then
    printf 'Installed init script not found: %s\n' "$init_script" >&2
    printf 'Run install first, or re-run without --skip-install.\n' >&2
    exit 1
  fi

  "$init_script" --repo "$REPO_PATH" --codex-home "$CODEX_HOME"
}

parse_args "$@"

if [ ! -d "$REPO_PATH" ]; then
  printf 'Target repository does not exist: %s\n' "$REPO_PATH" >&2
  exit 1
fi

require_git_repo

if [ "$SKIP_INSTALL" != "true" ]; then
  install_kit
fi

bootstrap_repo

local_repo_path="$(cd "$REPO_PATH" && pwd)"

printf '\nQuick onboarding done. Next:\n'
printf 'Open Codex in: %s\n' "$local_repo_path"
printf 'Start with this message:\n'
printf '  Plan this task before coding. Keep the workflow lightweight unless risk justifies more.\n'
printf '\nIf this task changes browser/runtime flows, then add:\n'
printf '  This changes a browser or runtime flow. Verify it before we call it done.\n'
