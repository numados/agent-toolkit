#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd -P)"
source "$script_dir/_context.sh"

profile=""
vault_path=""
project_dir=""
write_root=""
search_roots=""
backend=""
qmd_collection=""
link_style=""
vault_set=false
write_root_set=false
search_roots_set=false
backend_set=false
qmd_collection_set=false
link_style_set=false
set_default=false
update=false
force=false

usage() {
  printf '%s\n' 'Usage: configure-vault.sh --profile NAME [--vault ABSOLUTE_PATH] [--project DIR] [--default] [--update] [--write-root RELATIVE_DIR] [--search-roots CSV] [--backend auto|filesystem|obsidian|qmd] [--qmd-collection NAME] [--link-style preserve|wikilink|markdown] [--force]'
  printf '%s\n' 'Create a machine-local profile, merge-update supplied fields, or bind a project selector.'
  printf '%s\n' 'Example: configure-vault.sh --profile work --vault /absolute/vault --project /absolute/project'
}

write_file_atomically() {
  local destination="$1"
  local content="$2"
  local temporary="${destination}.tmp.$$"

  umask 077
  printf '%s' "$content" > "$temporary"
  mv "$temporary" "$destination"
}

validate_relative_dir() {
  local root="$1"
  local label="$2"
  numados_validate_vault_relative_dir "$vault_path" "$root" "$label"
}

validate_relative_dirs() {
  local roots="$1"
  local root
  [ -n "$roots" ] || return 0
  IFS=',' read -r -a root_list <<< "$roots"
  for root in "${root_list[@]}"; do
    validate_relative_dir "$root" 'Search root' || return 1
  done
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --profile) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; profile="$2"; shift 2;;
    --vault) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; vault_path="$2"; vault_set=true; shift 2;;
    --project) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; project_dir="$2"; shift 2;;
    --write-root) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; write_root="$2"; write_root_set=true; shift 2;;
    --search-roots) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; search_roots="$2"; search_roots_set=true; shift 2;;
    --backend) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; backend="$2"; backend_set=true; shift 2;;
    --qmd-collection) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; qmd_collection="$2"; qmd_collection_set=true; shift 2;;
    --link-style) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; link_style="$2"; link_style_set=true; shift 2;;
    --default) set_default=true; shift;;
    --update) update=true; shift;;
    --force) force=true; shift;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done

[ -n "$profile" ] || { printf '%s\n' '--profile is required.' >&2; exit 2; }
numados_validate_profile_name "$profile" || { printf 'Invalid profile name: %s\n' "$profile" >&2; exit 2; }

config_root="$(numados_config_root)"
profile_dir="$config_root/profiles"
profile_file="$(numados_profile_path "$profile")"
profile_exists=false
[ ! -f "$profile_file" ] || profile_exists=true
settings_changed=false

if [ "$vault_set" = true ] || [ "$write_root_set" = true ] || [ "$search_roots_set" = true ] || [ "$backend_set" = true ] || [ "$qmd_collection_set" = true ] || [ "$link_style_set" = true ]; then
  settings_changed=true
fi

if [ "$profile_exists" = true ]; then
  if [ "$settings_changed" = true ] && [ "$update" = false ]; then
    printf 'Profile exists; use --update to change only the supplied fields: %s\n' "$profile_file" >&2
    exit 4
  fi

  [ "$vault_set" = true ] || vault_path="$(numados_read_config_value NUMADOS_OBSIDIAN_VAULT "$profile_file")"
  [ "$write_root_set" = true ] || write_root="$(numados_read_config_value NUMADOS_OBSIDIAN_WRITE_ROOT "$profile_file")"
  [ "$search_roots_set" = true ] || search_roots="$(numados_read_config_value NUMADOS_OBSIDIAN_SEARCH_ROOTS "$profile_file")"
  [ "$backend_set" = true ] || backend="$(numados_read_config_value NUMADOS_OBSIDIAN_SEARCH_BACKEND "$profile_file")"
  [ "$qmd_collection_set" = true ] || qmd_collection="$(numados_read_config_value NUMADOS_OBSIDIAN_QMD_COLLECTION "$profile_file")"
  [ "$link_style_set" = true ] || link_style="$(numados_read_config_value NUMADOS_OBSIDIAN_LINK_STYLE "$profile_file")"
else
  [ "$update" = false ] || { printf 'Cannot update a missing profile: %s\n' "$profile" >&2; exit 4; }
  [ "$vault_set" = true ] || { printf '%s\n' '--vault is required when creating a profile.' >&2; exit 2; }
fi

backend="${backend:-auto}"
link_style="${link_style:-preserve}"

case "$vault_path" in /*) ;; *) printf 'Vault path must be absolute: %s\n' "$vault_path" >&2; exit 2;; esac
[ -d "$vault_path" ] || { printf 'Vault directory does not exist: %s\n' "$vault_path" >&2; exit 3; }
vault_path="$(cd "$vault_path" && pwd -P)"
case "$vault_path$qmd_collection" in *$'\n'*|*$'\r'*) printf '%s\n' 'Vault path and QMD collection must be single-line values.' >&2; exit 2;; esac
validate_relative_dir "$write_root" 'Write root' || exit 2
validate_relative_dirs "$search_roots" || exit 2
case "$backend" in auto|filesystem|obsidian|qmd) ;; *) printf 'Unsupported backend: %s\n' "$backend" >&2; exit 2;; esac
case "$link_style" in preserve|wikilink|markdown) ;; *) printf 'Unsupported link style: %s\n' "$link_style" >&2; exit 2;; esac
[ "$backend" != qmd ] || [ -n "$qmd_collection" ] || { printf '%s\n' '--qmd-collection is required for qmd.' >&2; exit 2; }

marker_dir=""
marker_file=""
if [ -n "$project_dir" ]; then
  [ -d "$project_dir" ] || { printf 'Project directory does not exist: %s\n' "$project_dir" >&2; exit 3; }
  project_dir="$(cd "$project_dir" && pwd -P)"
  marker_dir="$project_dir/.numados"
  marker_file="$marker_dir/obsidian-profile"
  if [ -e "$marker_file" ] && [ "$(numados_read_marker "$marker_file")" != "$profile" ] && [ "$force" = false ]; then
    printf 'Project already selects another profile; use --force to rebind it: %s\n' "$marker_file" >&2
    exit 4
  fi
fi

mkdir -p "$profile_dir"
chmod 700 "$config_root" "$profile_dir"

operation="unchanged"
if [ "$profile_exists" = false ] || [ "$settings_changed" = true ]; then
  profile_content="NUMADOS_OBSIDIAN_VAULT=$vault_path
NUMADOS_OBSIDIAN_WRITE_ROOT=$write_root
NUMADOS_OBSIDIAN_SEARCH_ROOTS=$search_roots
NUMADOS_OBSIDIAN_SEARCH_BACKEND=$backend
NUMADOS_OBSIDIAN_QMD_COLLECTION=$qmd_collection
NUMADOS_OBSIDIAN_LINK_STYLE=$link_style
"
  write_file_atomically "$profile_file" "$profile_content"
  if [ "$profile_exists" = true ]; then operation="updated"; else operation="created"; fi
fi

if [ "$set_default" = true ]; then
  write_file_atomically "$config_root/default-profile" "$profile
"
fi

if [ -n "$project_dir" ]; then
  mkdir -p "$marker_dir"
  write_file_atomically "$marker_file" "$profile
"
fi

printf 'operation: %s\n' "$operation"
printf 'profile: %s\n' "$profile"
printf 'vault: %s\n' "$vault_path"
printf 'config: %s\n' "$profile_file"
if [ "$set_default" = true ]; then printf 'default_profile: %s\n' "$profile"; fi
if [ -n "$project_dir" ]; then printf 'project_marker: %s\n' "$marker_file"; fi
