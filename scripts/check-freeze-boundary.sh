#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(pwd)"
FREEZE_FILE=""
BASE_REF=""

usage() {
  cat <<'EOF'
Usage: check-freeze-boundary.sh [--repo-root PATH] [--freeze-file PATH] [--base-ref REF]

Checks the current diff against a freeze contract.
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --repo-root)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        REPO_ROOT="$2"
        shift 2
        ;;
      --freeze-file)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        FREEZE_FILE="$2"
        shift 2
        ;;
      --base-ref)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        BASE_REF="$2"
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

collect_patterns() {
  local heading="$1"
  awk -v heading="$heading" '
    $0 == "## " heading { in_section=1; next }
    /^## / { in_section=0 }
    in_section && /^[[:space:]]*-[[:space:]]*/ {
      line=$0
      sub(/^[[:space:]]*-[[:space:]]*/, "", line)
      gsub(/`/, "", line)
      if (line != "") print line
    }
  ' "$FREEZE_FILE"
}

matches_any() {
  local path="$1"
  shift
  local pattern=""

  for pattern in "$@"; do
    case "$path" in
      $pattern)
        return 0
        ;;
    esac
  done

  return 1
}

collect_changed_files() {
  if [ -n "$BASE_REF" ]; then
    {
      git -C "$REPO_ROOT" diff --name-only --diff-filter=ACMR "$BASE_REF"...HEAD
      git -C "$REPO_ROOT" diff --name-only --diff-filter=ACMR HEAD
      git -C "$REPO_ROOT" diff --cached --name-only --diff-filter=ACMR
      git -C "$REPO_ROOT" ls-files --others --exclude-standard
    } | sort -u
    return 0
  fi

  if git -C "$REPO_ROOT" rev-parse --verify HEAD >/dev/null 2>&1; then
    {
      git -C "$REPO_ROOT" diff --name-only --diff-filter=ACMR HEAD
      git -C "$REPO_ROOT" diff --cached --name-only --diff-filter=ACMR
      git -C "$REPO_ROOT" ls-files --others --exclude-standard
    } | sort -u
  else
    git -C "$REPO_ROOT" ls-files --others --exclude-standard | sort -u
  fi
}

parse_args "$@"

REPO_ROOT="$(cd "$REPO_ROOT" && pwd)"
if [ -z "$FREEZE_FILE" ]; then
  FREEZE_FILE="$REPO_ROOT/.codex/context/FREEZE.md"
fi

if ! git -C "$REPO_ROOT" rev-parse --show-toplevel >/dev/null 2>&1; then
  printf 'Repository root is not a git repo: %s\n' "$REPO_ROOT" >&2
  exit 1
fi

if [ ! -f "$FREEZE_FILE" ]; then
  printf 'Freeze contract not found: %s\n' "$FREEZE_FILE" >&2
  exit 1
fi

allowed_patterns=()
while IFS= read -r line; do
  [ -n "$line" ] || continue
  allowed_patterns+=("$line")
done < <(collect_patterns "Allowed Paths")

blocked_patterns=()
while IFS= read -r line; do
  [ -n "$line" ] || continue
  blocked_patterns+=("$line")
done < <(collect_patterns "Blocked Paths")

changed_files=()
while IFS= read -r line; do
  [ -n "$line" ] || continue
  changed_files+=("$line")
done < <(collect_changed_files)

if [ "${#allowed_patterns[@]}" -eq 0 ]; then
  printf 'Freeze contract is missing an Allowed Paths section: %s\n' "$FREEZE_FILE" >&2
  exit 1
fi

violations=()
checked_files=0

for file in "${changed_files[@]}"; do
  [ -n "$file" ] || continue

  if [ "$file" = "${FREEZE_FILE#"$REPO_ROOT/"}" ]; then
    continue
  fi

  checked_files=$((checked_files + 1))

  if [ "${#blocked_patterns[@]}" -gt 0 ] && matches_any "$file" "${blocked_patterns[@]}"; then
    violations+=("blocked:$file")
    continue
  fi

  if ! matches_any "$file" "${allowed_patterns[@]}"; then
    violations+=("outside:$file")
  fi
done

printf 'freeze_file=%s\n' "$FREEZE_FILE"
printf 'checked_files=%s\n' "$checked_files"

if [ "${#violations[@]}" -eq 0 ]; then
  printf 'guard_status=PASS\n'
  exit 0
fi

printf 'guard_status=FAIL\n'
for violation in "${violations[@]}"; do
  printf 'violation=%s\n' "$violation"
done
exit 1
