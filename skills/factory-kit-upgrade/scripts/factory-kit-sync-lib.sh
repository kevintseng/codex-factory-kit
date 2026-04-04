#!/usr/bin/env bash

set -euo pipefail

copy_tree() {
  local src="$1"
  local dst="$2"

  mkdir -p "$dst"
  cp -R "$src"/. "$dst"/
}

list_contains() {
  local needle="$1"
  shift
  local item=""

  for item in "$@"; do
    if [ "$item" = "$needle" ]; then
      return 0
    fi
  done

  return 1
}

append_path_if_missing() {
  local value="$1"
  shift
  local -a existing=("$@")

  if ! list_contains "$value" "${existing[@]}"; then
    existing+=("$value")
  fi

  printf '%s\n' "${existing[@]}"
}

read_list_file() {
  local path="$1"
  local value=""

  if [ ! -f "$path" ]; then
    return 0
  fi

  while IFS= read -r value; do
    [ -n "$value" ] || continue
    printf '%s\n' "$value"
  done < "$path"
}

write_list_file() {
  local path="$1"
  shift
  local value=""

  mkdir -p "$(dirname "$path")"
  : > "$path"
  for value in "$@"; do
    [ -n "$value" ] || continue
    printf '%s\n' "$value" >> "$path"
  done
}

discover_skill_names() {
  local skills_root="$1"
  local skill_dir=""

  for skill_dir in "$skills_root"/*; do
    [ -d "$skill_dir" ] || continue
    basename "$skill_dir"
  done | sort
}

discover_template_paths() {
  local templates_root="$1"

  if [ ! -d "$templates_root" ]; then
    return 0
  fi

  (
    cd "$templates_root"
    find . -type f | sed 's#^\./##' | sort
  )
}

cleanup_empty_parent_dirs() {
  local root="$1"
  local path="$2"
  local parent=""

  parent="$(dirname "$path")"
  while [ "$parent" != "." ] && [ "$parent" != "/" ]; do
    rmdir "$root/$parent" 2>/dev/null || break
    parent="$(dirname "$parent")"
  done
}

sync_skill_surface() {
  local source_root="$1"
  local dest_root="$2"
  local metadata_file="$3"
  local verb="$4"
  local tracked=""
  local skill_name=""
  local -a current=()
  local -a tracked_items=()

  while IFS= read -r skill_name; do
    [ -n "$skill_name" ] || continue
    current+=("$skill_name")
  done < <(discover_skill_names "$source_root")

  while IFS= read -r tracked; do
    [ -n "$tracked" ] || continue
    tracked_items+=("$tracked")
  done < <(read_list_file "$metadata_file")

  mkdir -p "$dest_root"

  if [ "${#tracked_items[@]}" -gt 0 ]; then
    for tracked in "${tracked_items[@]}"; do
      if list_contains "$tracked" "${current[@]}"; then
        continue
      fi

      rm -rf "$dest_root/$tracked"
      printf 'removed_retired_skill=%s\n' "$tracked"
    done
  fi

  if [ "${#current[@]}" -gt 0 ]; then
    for skill_name in "${current[@]}"; do
      rm -rf "$dest_root/$skill_name"
      copy_tree "$source_root/$skill_name" "$dest_root/$skill_name"
      printf '%s=%s\n' "$verb" "$skill_name"
    done
  fi

  write_list_file "$metadata_file" "${current[@]}"
}

sync_template_surface() {
  local source_root="$1"
  local dest_root="$2"
  local metadata_file="$3"
  local tracked=""
  local relpath=""
  local -a current=()
  local -a tracked_items=()

  while IFS= read -r relpath; do
    [ -n "$relpath" ] || continue
    current+=("$relpath")
  done < <(discover_template_paths "$source_root")

  while IFS= read -r tracked; do
    [ -n "$tracked" ] || continue
    tracked_items+=("$tracked")
  done < <(read_list_file "$metadata_file")

  mkdir -p "$dest_root"

  if [ "${#tracked_items[@]}" -gt 0 ]; then
    for tracked in "${tracked_items[@]}"; do
      if list_contains "$tracked" "${current[@]}"; then
        continue
      fi

      rm -f "$dest_root/$tracked"
      cleanup_empty_parent_dirs "$dest_root" "$tracked"
      printf 'removed_retired_template=%s\n' "$tracked"
    done
  fi

  if [ "${#current[@]}" -gt 0 ]; then
    for relpath in "${current[@]}"; do
      mkdir -p "$dest_root/$(dirname "$relpath")"
      cp "$source_root/$relpath" "$dest_root/$relpath"
    done
  fi

  write_list_file "$metadata_file" "${current[@]}"
}
