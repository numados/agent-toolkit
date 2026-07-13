#!/usr/bin/env bash

numados_read_config_value() {
  local key="$1"
  local file="$2"

  [ -f "$file" ] || return 0
  awk -F= -v wanted="$key" '
    $0 !~ /^[[:space:]]*#/ && $1 == wanted {
      value = substr($0, index($0, "=") + 1)
      sub(/^[[:space:]]+/, "", value)
      sub(/[[:space:]]+$/, "", value)
      print value
      exit
    }
  ' "$file"
}

numados_read_marker() {
  local file="$1"

  awk '
    $0 !~ /^[[:space:]]*#/ && $0 !~ /^[[:space:]]*$/ {
      value = $0
      sub(/^[[:space:]]+/, "", value)
      sub(/[[:space:]]+$/, "", value)
      sub(/\r$/, "", value)
      print value
      exit
    }
  ' "$file"
}

numados_validate_profile_name() {
  [[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]
}

numados_config_root() {
  printf '%s/numados/obsidian' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

numados_profile_path() {
  local profile="$1"
  printf '%s/profiles/%s.env' "$(numados_config_root)" "$profile"
}

numados_validate_vault_relative_dir() {
  local vault_path="$1"
  local relative_path="$2"
  local label="$3"
  local resolved_path

  [ -n "$relative_path" ] || return 0
  case "$relative_path" in
    /*) printf '%s must be vault-relative: %s\n' "$label" "$relative_path" >&2; return 1;;
    *$'\n'*|*$'\r'*) printf '%s must be a single-line path.\n' "$label" >&2; return 1;;
  esac
  case "/$relative_path/" in
    /*/../*|/*/./*) printf '%s must be a clean relative path: %s\n' "$label" "$relative_path" >&2; return 1;;
  esac
  [ -d "$vault_path/$relative_path" ] || { printf '%s does not exist: %s\n' "$label" "$relative_path" >&2; return 1; }

  resolved_path="$(cd "$vault_path/$relative_path" && pwd -P)" || return 1
  case "$resolved_path/" in
    "$vault_path/"*) ;;
    *) printf '%s resolves outside the vault: %s\n' "$label" "$relative_path" >&2; return 1;;
  esac
}

numados_find_project_profile() {
  local start_dir="$1"
  local directory
  local marker
  local profile
  local parent

  NUMADOS_FOUND_PROFILE=""
  NUMADOS_FOUND_MARKER=""
  directory="$(cd "$start_dir" && pwd -P)" || return 1

  while true; do
    marker="$directory/.numados/obsidian-profile"
    if [ -f "$marker" ]; then
      profile="$(numados_read_marker "$marker")"
      [ -n "$profile" ] || { printf 'Empty Obsidian profile marker: %s\n' "$marker" >&2; return 2; }
      numados_validate_profile_name "$profile" || { printf 'Invalid Obsidian profile name in %s: %s\n' "$marker" "$profile" >&2; return 2; }
      NUMADOS_FOUND_PROFILE="$profile"
      NUMADOS_FOUND_MARKER="$marker"
      return 0
    fi

    [ "$directory" = / ] && break
    parent="${directory%/*}"
    [ -n "$parent" ] || parent=/
    [ "$parent" = "$directory" ] && break
    directory="$parent"
  done

  return 1
}

numados_resolve_context() {
  local explicit_vault="$1"
  local explicit_config="$2"
  local explicit_profile="$3"
  local start_dir="$4"
  local config_root
  local default_marker
  local legacy_config
  local profile=""
  local config_path=""
  local config_source=""
  local configured_vault=""
  local project_status=0

  NUMADOS_RESOLVED_VAULT=""
  NUMADOS_RESOLVED_CONFIG=""
  NUMADOS_RESOLVED_PROFILE=""
  NUMADOS_RESOLVED_SOURCE=""
  NUMADOS_RESOLVED_MARKER=""

  config_root="$(numados_config_root)"
  default_marker="$config_root/default-profile"
  legacy_config="${XDG_CONFIG_HOME:-$HOME/.config}/numados/obsidian-knowledge.env"

  if [ -n "$explicit_config" ] && [ -n "$explicit_profile" ]; then
    printf '%s\n' 'Use either --config or --profile, not both.' >&2
    return 2
  fi

  if [ -n "$explicit_config" ]; then
    config_path="$explicit_config"
    config_source="explicit-config"
  elif [ -n "$explicit_profile" ]; then
    profile="$explicit_profile"
    config_source="explicit-profile"
  elif [ -n "$explicit_vault" ]; then
    :
  elif [ -n "${NUMADOS_OBSIDIAN_VAULT:-}" ]; then
    :
  elif [ -n "${NUMADOS_OBSIDIAN_PROFILE:-}" ]; then
    profile="$NUMADOS_OBSIDIAN_PROFILE"
    config_source="environment-profile"
  else
    if numados_find_project_profile "$start_dir"; then
      profile="$NUMADOS_FOUND_PROFILE"
      NUMADOS_RESOLVED_MARKER="$NUMADOS_FOUND_MARKER"
      config_source="project-profile"
    else
      project_status=$?
      [ "$project_status" -ne 2 ] || return 2
      if [ -f "$default_marker" ]; then
        profile="$(numados_read_marker "$default_marker")"
        config_source="default-profile"
      elif [ -f "$legacy_config" ]; then
        config_path="$legacy_config"
        config_source="legacy-config"
      fi
    fi
  fi

  if [ -n "$profile" ]; then
    numados_validate_profile_name "$profile" || { printf 'Invalid Obsidian profile name: %s\n' "$profile" >&2; return 2; }
    config_path="$(numados_profile_path "$profile")"
    if [ ! -f "$config_path" ]; then
      printf 'Obsidian profile %s is not configured on this machine: %s\n' "$profile" "$config_path" >&2
      return 3
    fi
  elif [ -n "$config_path" ] && [ ! -f "$config_path" ]; then
    printf 'Obsidian config does not exist: %s\n' "$config_path" >&2
    return 3
  fi

  if [ -n "$config_path" ]; then
    configured_vault="$(numados_read_config_value NUMADOS_OBSIDIAN_VAULT "$config_path")"
  fi

  if [ -n "$explicit_vault" ]; then
    NUMADOS_RESOLVED_VAULT="$explicit_vault"
    NUMADOS_RESOLVED_SOURCE="explicit-vault"
  elif [ "$config_source" = explicit-config ] || [ "$config_source" = explicit-profile ]; then
    NUMADOS_RESOLVED_VAULT="$configured_vault"
    NUMADOS_RESOLVED_SOURCE="$config_source"
  elif [ -n "${NUMADOS_OBSIDIAN_VAULT:-}" ]; then
    NUMADOS_RESOLVED_VAULT="$NUMADOS_OBSIDIAN_VAULT"
    NUMADOS_RESOLVED_SOURCE="environment-vault"
  elif [ -n "$configured_vault" ]; then
    NUMADOS_RESOLVED_VAULT="$configured_vault"
    NUMADOS_RESOLVED_SOURCE="$config_source"
  fi

  NUMADOS_RESOLVED_CONFIG="$config_path"
  NUMADOS_RESOLVED_PROFILE="$profile"

  if [ -z "$NUMADOS_RESOLVED_VAULT" ]; then
    printf '%s\n' 'No vault configured. Pass --vault/--profile, set NUMADOS_OBSIDIAN_VAULT or NUMADOS_OBSIDIAN_PROFILE, add .numados/obsidian-profile, or configure a default profile.' >&2
    return 3
  fi

  case "$NUMADOS_RESOLVED_VAULT" in
    *$'\n'*|*$'\r'*) printf '%s\n' 'Vault path must be a single-line value.' >&2; return 4;;
  esac

  case "$NUMADOS_RESOLVED_VAULT" in
    /*) ;;
    *) printf 'Vault path must be absolute: %s\n' "$NUMADOS_RESOLVED_VAULT" >&2; return 4;;
  esac

  if [ ! -d "$NUMADOS_RESOLVED_VAULT" ]; then
    printf 'Vault directory does not exist: %s\n' "$NUMADOS_RESOLVED_VAULT" >&2
    return 5
  fi

  NUMADOS_RESOLVED_VAULT="$(cd "$NUMADOS_RESOLVED_VAULT" && pwd -P)"
}

numados_context_value() {
  local key="$1"
  local environment_value="${!key:-}"

  if [ -n "$environment_value" ]; then
    printf '%s' "$environment_value"
  elif [ -n "${NUMADOS_RESOLVED_CONFIG:-}" ]; then
    numados_read_config_value "$key" "$NUMADOS_RESOLVED_CONFIG"
  fi
}
