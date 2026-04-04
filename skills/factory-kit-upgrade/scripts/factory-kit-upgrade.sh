#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
COMMAND=""
SOURCE_REPO_OVERRIDE=""
ALLOW_DOWNGRADE="false"
RELEASE_REPO="${FACTORY_KIT_RELEASE_REPO:-kevintseng/codex-factory-kit}"
RELEASE_JSON_FILE=""

looks_like_repo_checkout() {
  local candidate="$1"
  [ -f "$candidate/VERSION" ] &&
    [ -f "$candidate/AGENTS.md" ] &&
    [ -f "$candidate/install.sh" ] &&
    [ -d "$candidate/skills" ] &&
    [ -d "$candidate/templates/factory" ]
}

detect_default_source_repo() {
  local stored_source_repo=""

  if looks_like_repo_checkout "$PWD"; then
    printf '%s\n' "$PWD"
    return 0
  fi

  if [ -f "$CODEX_HOME/factory-kit/SOURCE_REPO" ]; then
    stored_source_repo="$(cat "$CODEX_HOME/factory-kit/SOURCE_REPO")"
    if looks_like_repo_checkout "$stored_source_repo"; then
      printf '%s\n' "$stored_source_repo"
      return 0
    fi
  fi

  if looks_like_repo_checkout "$SCRIPT_DIR/../../../"; then
    cd "$SCRIPT_DIR/../../../" && pwd
    return 0
  fi

  printf 'unknown\n'
}

usage() {
  cat <<'EOF'
Usage:
  factory-kit-upgrade.sh status [--source-repo PATH] [--codex-home PATH]
  factory-kit-upgrade.sh check-updates [--source-repo PATH] [--codex-home PATH] [--release-repo OWNER/REPO]
  factory-kit-upgrade.sh upgrade [--source-repo PATH] [--codex-home PATH]

Commands:
  status         Print source and installed version information
  check-updates  Compare local versions against the latest published release
  upgrade        Refresh the selected CODEX_HOME from the source repo checkout
EOF
}

require_python3() {
  if ! command -v python3 >/dev/null 2>&1; then
    printf 'python3 is required for release metadata parsing.\n' >&2
    exit 1
  fi
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      status|check-updates|upgrade)
        if [ -n "$COMMAND" ]; then
          printf 'Command specified multiple times: %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        COMMAND="$1"
        shift
        ;;
      --source-repo)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        SOURCE_REPO_OVERRIDE="$2"
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
      --allow-downgrade)
        ALLOW_DOWNGRADE="true"
        shift
        ;;
      --release-repo)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        RELEASE_REPO="$2"
        shift 2
        ;;
      --release-json-file)
        if [ "$#" -lt 2 ]; then
          printf 'Missing value for %s\n' "$1" >&2
          usage >&2
          exit 1
        fi
        RELEASE_JSON_FILE="$2"
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

resolve_source_repo() {
  if [ -n "$SOURCE_REPO_OVERRIDE" ]; then
    printf '%s\n' "$SOURCE_REPO_OVERRIDE"
  else
    detect_default_source_repo
  fi
}

compare_versions() {
  local left="${1#v}"
  local right="${2#v}"
  local left_core="${left%%-*}"
  local right_core="${right%%-*}"
  local left_suffix=""
  local right_suffix=""
  local left_major=0 left_minor=0 left_patch=0
  local right_major=0 right_minor=0 right_patch=0

  if [ "$left_core" != "$left" ]; then
    left_suffix="${left#"$left_core-"}"
  fi

  if [ "$right_core" != "$right" ]; then
    right_suffix="${right#"$right_core-"}"
  fi

  IFS=. read -r left_major left_minor left_patch <<EOF
$left_core
EOF
  IFS=. read -r right_major right_minor right_patch <<EOF
$right_core
EOF

  for value in "$left_major" "$left_minor" "$left_patch" "$right_major" "$right_minor" "$right_patch"; do
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
      printf 'unknown\n'
      return 0
    fi
  done

  if [ "$left_major" -gt "$right_major" ]; then
    printf 'gt\n'
    return 0
  elif [ "$left_major" -lt "$right_major" ]; then
    printf 'lt\n'
    return 0
  fi

  if [ "$left_minor" -gt "$right_minor" ]; then
    printf 'gt\n'
    return 0
  elif [ "$left_minor" -lt "$right_minor" ]; then
    printf 'lt\n'
    return 0
  fi

  if [ "$left_patch" -gt "$right_patch" ]; then
    printf 'gt\n'
    return 0
  elif [ "$left_patch" -lt "$right_patch" ]; then
    printf 'lt\n'
    return 0
  fi

  if [ -z "$left_suffix" ] && [ -z "$right_suffix" ]; then
    printf 'eq\n'
  elif [ -z "$left_suffix" ]; then
    printf 'gt\n'
  elif [ -z "$right_suffix" ]; then
    printf 'lt\n'
  elif [ "$left_suffix" = "$right_suffix" ]; then
    printf 'eq\n'
  else
    printf 'unknown\n'
  fi
}

classify_version_relation() {
  local source_version="$1"
  local installed="$2"
  local comparison=""

  if [ "$source_version" = "unknown" ]; then
    printf 'unknown\n'
    return 0
  fi

  if [ "$installed" = "not-installed" ]; then
    printf 'install\n'
    return 0
  fi

  comparison="$(compare_versions "$source_version" "$installed")"

  case "$comparison" in
    gt)
      printf 'upgrade\n'
      ;;
    eq)
      printf 'current\n'
      ;;
    lt)
      printf 'downgrade\n'
      ;;
    *)
      printf 'unknown\n'
      ;;
  esac
}

write_install_metadata() {
  local source_repo="$1"

  printf '%s\n' "$source_repo" > "$CODEX_HOME/factory-kit/SOURCE_REPO"
}

require_repo_checkout() {
  local repo="$1"

  for path in VERSION AGENTS.md install.sh skills templates/factory; do
    if [ ! -e "$repo/$path" ]; then
      printf 'Source repo is missing required path: %s\n' "$repo/$path" >&2
      exit 1
    fi
  done
}

repo_version() {
  cat "$SOURCE_REPO/VERSION"
}

installed_version_path() {
  printf '%s/factory-kit/VERSION\n' "$CODEX_HOME"
}

installed_version() {
  local version_path
  version_path="$(installed_version_path)"
  if [ -f "$version_path" ]; then
    cat "$version_path"
  else
    printf 'not-installed\n'
  fi
}

detect_install_root() {
  printf '%s\n' "$CODEX_HOME"
}

update_state_path() {
  printf '%s/factory-kit/update-state.json\n' "$CODEX_HOME"
}

utc_timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

fetch_latest_release_json() {
  if [ -n "$RELEASE_JSON_FILE" ]; then
    cat "$RELEASE_JSON_FILE"
    return 0
  fi

  if command -v gh >/dev/null 2>&1; then
    if gh api "repos/$RELEASE_REPO/releases/latest" 2>/dev/null; then
      return 0
    fi
  fi

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "https://api.github.com/repos/$RELEASE_REPO/releases/latest"
    return 0
  fi

  printf 'Could not fetch release metadata for %s. Install `gh` or `curl`, or pass --release-json-file.\n' "$RELEASE_REPO" >&2
  exit 1
}

parse_latest_release_field() {
  local field="$1"

  require_python3
  python3 -c '
import json
import sys

field = sys.argv[1]
data = json.load(sys.stdin)
value = data.get(field, "")
if value is None:
    value = ""
sys.stdout.write(str(value))
' "$field"
}

latest_release_version() {
  local tag="$1"
  printf '%s\n' "${tag#v}"
}

classify_release_relation() {
  local latest_version="$1"
  local local_version="$2"
  local comparison=""

  if [ -z "$latest_version" ] || [ "$latest_version" = "unknown" ]; then
    printf 'unknown\n'
    return 0
  fi

  if [ "$local_version" = "not-installed" ]; then
    printf 'not_installed\n'
    return 0
  fi

  if [ "$local_version" = "unknown" ]; then
    printf 'unknown\n'
    return 0
  fi

  comparison="$(compare_versions "$local_version" "$latest_version")"

  case "$comparison" in
    lt)
      printf 'behind\n'
      ;;
    eq)
      printf 'current\n'
      ;;
    gt)
      printf 'ahead\n'
      ;;
    *)
      printf 'unknown\n'
      ;;
  esac
}

write_update_state() {
  local checked_at="$1"
  local latest_tag="$2"
  local latest_version="$3"
  local latest_url="$4"
  local published_at="$5"
  local installed="$6"
  local source_version="$7"
  local installed_relation="$8"
  local source_relation="$9"
  local update_available="${10}"

  mkdir -p "$CODEX_HOME/factory-kit"
  cat > "$(update_state_path)" <<EOF
{
  "release_authority": "$RELEASE_REPO",
  "checked_at": "$checked_at",
  "latest_release_tag": "$latest_tag",
  "latest_release_version": "$latest_version",
  "latest_release_url": "$latest_url",
  "latest_release_published_at": "$published_at",
  "installed_version": "$installed",
  "source_version": "$source_version",
  "installed_release_relation": "$installed_relation",
  "source_release_relation": "$source_relation",
  "update_available": "$update_available"
}
EOF
}

print_status() {
  local source_version installed target_root update_available source_repo relation
  source_repo="$(resolve_source_repo)"
  source_version="unknown"
  installed="$(installed_version)"
  target_root="$(detect_install_root)"
  relation="unknown"

  if [ "$source_repo" != "unknown" ]; then
    SOURCE_REPO="$source_repo"
    require_repo_checkout "$SOURCE_REPO"
    source_version="$(repo_version)"
    relation="$(classify_version_relation "$source_version" "$installed")"
  fi

  if [ "$relation" = "install" ] || [ "$relation" = "upgrade" ]; then
    update_available="yes"
  elif [ "$relation" = "current" ] || [ "$relation" = "downgrade" ]; then
    update_available="no"
  else
    update_available="unknown"
  fi

  printf 'source_repo=%s\n' "$source_repo"
  printf 'source_version=%s\n' "$source_version"
  printf 'codex_home=%s\n' "$CODEX_HOME"
  printf 'install_root=%s\n' "$target_root"
  printf 'installed_version=%s\n' "$installed"
  printf 'version_relation=%s\n' "$relation"
  printf 'update_available=%s\n' "$update_available"
}

copy_tree() {
  local src="$1"
  local dst="$2"

  mkdir -p "$dst"
  cp -R "$src"/. "$dst"/
}

run_upgrade() {
  local installed source_version relation

  SOURCE_REPO="$(resolve_source_repo)"
  if [ "$SOURCE_REPO" = "unknown" ]; then
    printf 'Could not resolve a source repo checkout. Run this command from the repo checkout or pass --source-repo PATH.\n' >&2
    exit 1
  fi

  require_repo_checkout "$SOURCE_REPO"

  source_version="$(repo_version)"
  installed="$(installed_version)"
  relation="$(classify_version_relation "$source_version" "$installed")"

  if [ "$relation" = "unknown" ]; then
    printf 'Could not safely compare source_version=%s with installed_version=%s.\n' "$source_version" "$installed" >&2
    exit 1
  fi

  if [ "$relation" = "downgrade" ] && [ "$ALLOW_DOWNGRADE" != "true" ]; then
    printf 'Refusing to overwrite installed_version=%s with older source_version=%s. Re-run with --allow-downgrade if this is intentional.\n' "$installed" "$source_version" >&2
    exit 1
  fi

  mkdir -p "$CODEX_HOME/skills"
  mkdir -p "$CODEX_HOME/templates/factory"
  mkdir -p "$CODEX_HOME/factory-kit"

  local skill_dir skill_name
  for skill_dir in "$SOURCE_REPO"/skills/*; do
    skill_name="$(basename "$skill_dir")"
    rm -rf "$CODEX_HOME/skills/$skill_name"
    copy_tree "$skill_dir" "$CODEX_HOME/skills/$skill_name"
    printf 'refreshed_skill=%s\n' "$skill_name"
  done

  rm -rf "$CODEX_HOME/templates/factory"
  copy_tree "$SOURCE_REPO/templates/factory" "$CODEX_HOME/templates/factory"
  cp "$SOURCE_REPO/AGENTS.md" "$CODEX_HOME/AGENTS.factory-kit.md"
  cp "$SOURCE_REPO/VERSION" "$CODEX_HOME/factory-kit/VERSION"
  write_install_metadata "$SOURCE_REPO"

  if [ -f "$SOURCE_REPO/CHANGELOG.md" ]; then
    cp "$SOURCE_REPO/CHANGELOG.md" "$CODEX_HOME/factory-kit/CHANGELOG.md"
  fi

  printf 'source_repo=%s\n' "$SOURCE_REPO"
  printf 'codex_home=%s\n' "$CODEX_HOME"
  printf 'version_relation=%s\n' "$relation"
  printf 'installed_version=%s\n' "$(installed_version)"
}

run_check_updates() {
  local source_repo source_version installed target_root checked_at
  local latest_json latest_tag latest_version latest_url latest_published_at
  local installed_relation source_relation update_available

  source_repo="$(resolve_source_repo)"
  source_version="unknown"
  installed="$(installed_version)"
  target_root="$(detect_install_root)"
  checked_at="$(utc_timestamp)"

  if [ "$source_repo" != "unknown" ]; then
    SOURCE_REPO="$source_repo"
    require_repo_checkout "$SOURCE_REPO"
    source_version="$(repo_version)"
  fi

  require_python3
  latest_json="$(fetch_latest_release_json)"
  latest_tag="$(printf '%s' "$latest_json" | parse_latest_release_field tag_name)"
  latest_url="$(printf '%s' "$latest_json" | parse_latest_release_field html_url)"
  latest_published_at="$(printf '%s' "$latest_json" | parse_latest_release_field published_at)"

  if [ -z "$latest_tag" ]; then
    printf 'Release authority %s did not return a latest release tag.\n' "$RELEASE_REPO" >&2
    exit 1
  fi

  latest_version="$(latest_release_version "$latest_tag")"
  installed_relation="$(classify_release_relation "$latest_version" "$installed")"
  source_relation="$(classify_release_relation "$latest_version" "$source_version")"

  if [ "$installed_relation" = "behind" ] || [ "$installed_relation" = "not_installed" ]; then
    update_available="yes"
  elif [ "$installed_relation" = "current" ] || [ "$installed_relation" = "ahead" ]; then
    update_available="no"
  else
    update_available="unknown"
  fi

  write_update_state \
    "$checked_at" \
    "$latest_tag" \
    "$latest_version" \
    "$latest_url" \
    "$latest_published_at" \
    "$installed" \
    "$source_version" \
    "$installed_relation" \
    "$source_relation" \
    "$update_available"

  printf 'release_authority=%s\n' "$RELEASE_REPO"
  printf 'checked_at=%s\n' "$checked_at"
  printf 'latest_release_tag=%s\n' "$latest_tag"
  printf 'latest_release_version=%s\n' "$latest_version"
  printf 'latest_release_url=%s\n' "$latest_url"
  printf 'latest_release_published_at=%s\n' "$latest_published_at"
  printf 'source_repo=%s\n' "$source_repo"
  printf 'source_version=%s\n' "$source_version"
  printf 'source_release_relation=%s\n' "$source_relation"
  printf 'codex_home=%s\n' "$CODEX_HOME"
  printf 'install_root=%s\n' "$target_root"
  printf 'installed_version=%s\n' "$installed"
  printf 'installed_release_relation=%s\n' "$installed_relation"
  printf 'update_available=%s\n' "$update_available"
  printf 'update_state_path=%s\n' "$(update_state_path)"
}

parse_args "$@"
if [ -z "$COMMAND" ]; then
  COMMAND="status"
fi

case "$COMMAND" in
  status)
    print_status
    ;;
  check-updates)
    run_check_updates
    ;;
  upgrade)
    run_upgrade
    ;;
  --help|-h|help)
    usage
    ;;
  *)
    printf 'Unknown command: %s\n' "$COMMAND" >&2
    usage >&2
    exit 1
    ;;
esac
