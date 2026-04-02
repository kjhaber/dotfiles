#!/bin/bash
# Shared config-merge library for agent launcher scripts (claude, cursor-agent, etc.).
# Source this file — do not execute it directly.
#
# Requires: $TMP set to a writable temp dir (caller creates it and traps cleanup).
#
# Functions:
#   merge_json         src_global src_local dest label  — full-file JSON merge + drift detect
#   merge_json_partial src_global src_local dest label  — key-scoped JSON merge + patch
#   merge_dir          src_global src_local dest label  — recursive dir merge + orphan detect
#   merge_md           src_global src_local dest label  — Markdown concat + drift detect

# jq: deep-merge two JSON values. Objects recurse; arrays concatenate (global then local);
# local wins for scalars and when types disagree (matches prior $a * $b intent).
# NOTE: jq's object multiply (*) replaces nested arrays with the rhs; we recurse so
# e.g. permissions.allow from global and local both apply.
read -r -d '' _MERGE_JSON_DEEP_JQ <<'JQ' || true
def deep_merge(a; b):
  if (a | type) != "object" or (b | type) != "object" then
    if (a | type) == "array" and (b | type) == "array" then a + b else b end
  else
    (a | keys_unsorted + (b | keys_unsorted) | unique)
    | map(. as $k |
        if (a[$k] | type) == "object" and (b[$k] | type) == "object" then
          {($k): deep_merge(a[$k]; b[$k])}
        elif (a[$k] | type) == "array" and (b[$k] | type) == "array" then
          {($k): (a[$k] + b[$k])}
        elif (b | has($k)) then
          {($k): b[$k]}
        else
          {($k): a[$k]}
        end)
    | add // {}
  end;
(.[0]) as $g | (.[1]) as $l | deep_merge($g; $l)
JQ

# merge_json: merge global + local JSON -> dest (replaces dest entirely).
# Arrays at any depth are concatenated (global + local); scalars in local override global.
# Prompts if dest has drifted from the merged result.
merge_json() {
  local src_global="$1" src_local="$2" dest="$3" label="$4"
  local merged dest_fmt
  merged="$TMP/$(basename "$dest")"
  dest_fmt="$TMP/$(basename "$dest").orig"

  [[ -f "$src_global" ]] || return 0

  # Use -r not -f: local may be a FIFO (e.g. process substitution); -f is false for pipes.
  if [[ -r "$src_local" ]]; then
    jq -s "$_MERGE_JSON_DEEP_JQ" "$src_global" "$src_local" | jq -S . > "$merged"
  else
    jq -S . "$src_global" > "$merged"
  fi

  if [[ -f "$dest" ]]; then
    jq -S . "$dest" > "$dest_fmt"
    if ! diff -q "$merged" "$dest_fmt" > /dev/null 2>&1; then
      echo "⚠️  $label has drifted from merged config:"
      diff --color=always "$merged" "$dest_fmt" || true
      echo
      printf "  [o] Overwrite  [k] Keep  [e] Exit: "
      read -r choice
      case "$choice" in
        o) cp "$merged" "$dest" ;;
        k) ;;
        *) exit 1 ;;
      esac
    fi
  else
    cp "$merged" "$dest"
  fi
}

# merge_json_partial: merge global + local JSON -> dest (key-scoped; other dest keys untouched).
# Only top-level keys present in the source files are managed.
# Arrays at any depth are concatenated (global + local); scalars in local override global.
# Drift is detected and patched only on the managed keys.
merge_json_partial() {
  local src_global="$1" src_local="$2" dest="$3" label="$4"
  local merged dest_subset patched
  merged="$TMP/$(basename "$dest").merged"
  dest_subset="$TMP/$(basename "$dest").subset"
  patched="$TMP/$(basename "$dest").patched"

  [[ -f "$src_global" ]] || return 0

  if [[ -r "$src_local" ]]; then
    jq -s "$_MERGE_JSON_DEEP_JQ" "$src_global" "$src_local" | jq -S . > "$merged"
  else
    jq -S . "$src_global" > "$merged"
  fi

  if [[ -f "$dest" ]]; then
    # Extract only the managed keys from dest for comparison
    jq -S --argjson m "$(cat "$merged")" \
      'with_entries(select(.key as $k | $m | has($k)))' "$dest" > "$dest_subset"
    if ! diff -q "$merged" "$dest_subset" > /dev/null 2>&1; then
      echo "⚠️  $label (managed keys) has drifted from merged config:"
      diff --color=always "$merged" "$dest_subset" || true
      echo
      printf "  [o] Overwrite  [k] Keep  [e] Exit: "
      read -r choice
      case "$choice" in
        o)
          # Replace only managed keys in dest; leave all other keys untouched
          jq -s 'reduce (.[1] | keys[]) as $k (.[0]; .[$k] = .[1][$k])' \
            "$dest" "$merged" > "$patched"
          cp "$patched" "$dest"
          ;;
        k) ;;
        *) exit 1 ;;
      esac
    fi
  else
    cp "$merged" "$dest"
  fi
}

# merge_dir: merge global + local dirs -> dest (local wins on conflict).
# Copies all non-hidden files and subdirectories recursively.
# Reports files in dest that came from neither source (created by the agent).
merge_dir() {
  local src_global="$1" src_local="$2" dest="$3" label="$4"
  local expected="$TMP/${label}_expected.txt"

  mkdir -p "$dest"

  if [[ -d "$src_global" ]]; then
    cp -rp "$src_global/." "$dest/"
    while IFS= read -r -d '' f; do
      echo "${f#"$src_global"/}" >> "$expected"
    done < <(find "$src_global" -not -name ".*" -type f -print0 2>/dev/null)
  fi

  if [[ -d "$src_local" ]]; then
    cp -rp "$src_local/." "$dest/"
    while IFS= read -r -d '' f; do
      rel="${f#"$src_local"/}"
      grep -qxF "$rel" "$expected" 2>/dev/null || echo "$rel" >> "$expected"
    done < <(find "$src_local" -not -name ".*" -type f -print0 2>/dev/null)
  fi

  # Detect orphans: non-hidden files in dest not sourced from either dir
  local orphans=()
  while IFS= read -r -d '' f; do
    rel="${f#"$dest"/}"
    grep -qxF "$rel" "$expected" 2>/dev/null || orphans+=("$rel")
  done < <(find "$dest" -not -name ".*" -type f -print0 2>/dev/null)

  if [[ ${#orphans[@]} -gt 0 ]]; then
    echo "⚠️  $label/ has files not in either source:"
    printf '    %s\n' "${orphans[@]}"
    echo
    printf "  [k] Keep  [d] Delete  [e] Exit: "
    read -r choice
    case "$choice" in
      d) for f in "${orphans[@]}"; do rm "$dest/$f"; done ;;
      k) ;;
      *) exit 1 ;;
    esac
  fi
}

# merge_md: merge global + local Markdown -> dest (global then local, blank line between).
# Prompts if dest has drifted from the merged result.
merge_md() {
  local src_global="$1" src_local="$2" dest="$3" label="$4"
  local merged
  merged="$TMP/$(basename "$dest")"

  [[ -f "$src_global" ]] || return 0

  if [[ -f "$src_local" ]]; then
    { cat "$src_global"; echo; cat "$src_local"; } > "$merged"
  else
    cp "$src_global" "$merged"
  fi

  if [[ -f "$dest" ]]; then
    if ! diff -q "$merged" "$dest" > /dev/null 2>&1; then
      echo "⚠️  $label has drifted from merged config:"
      diff --color=always "$merged" "$dest" || true
      echo
      printf "  [o] Overwrite  [k] Keep  [e] Exit: "
      read -r choice
      case "$choice" in
        o) cp "$merged" "$dest" ;;
        k) ;;
        *) exit 1 ;;
      esac
    fi
  else
    cp "$merged" "$dest"
  fi
}
