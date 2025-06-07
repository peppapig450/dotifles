# Utility functions for the alias-functions scripts/functions.

# ────────────────────────────────────────────────────────────────────────────
# JSON file location
# ────────────────────────────────────────────────────────────────────────────
readonly ALIAS_HELP_FILE="${ZDOTDIR}/aliases/alias-descriptions.json"

# ────────────────────────────────────────────────────────────────────────────
# Common file read check
# ────────────────────────────────────────────────────────────────────────────
check_json_file() {
  [[ -r "$ALIAS_HELP_FILE" ]] || {
    alias_print red "Error: Cannot read JSON file at $ALIAS_HELP_FILE"
    return 1
  }
}

# ────────────────────────────────────────────────────────────────────────────
# Colored echo wrapper
# Usage: alias_print <color> <text>
# Example: alias_print cyan "Hello, world!"
# ────────────────────────────────────────────────────────────────────────────
alias_print() {
    local color="$1"; shift
    if [[ -z ${color} || $# -eq 0 ]]; then
        print "Usage: alias_print <color> <text>"
        return 1
    fi

    # -P enables prompt style expansion (%F{color} ... %f)
    print -P "%F{$color}$*%f"
}

# ────────────────────────────────────────────────────────────────────────────
# List all alias groups and aliases (with descriptions)
# Outputs lines like: group::alias: description
# ────────────────────────────────────────────────────────────────────────────
alias_list_all() {
    check_json_file || return 1
    
    jq -r '
        to_entries[] as $group_entry |
        $group_entry.key as $group |
        $group_entry.value | to_entries[] |
        "\($group)::\(.key): \(.value)"
    ' "$ALIAS_HELP_FILE"
}

# ────────────────────────────────────────────────────────────────────────────
# List all alias names (ignoring their group)
# Outputs just the alias names, one per line
# ────────────────────────────────────────────────────────────────────────────
alias_list_names() {
    check_json_file || return 1

    jq -r 'to_entries[] | .value | keys[]' "$ALIAS_HELP_FILE"
}

# ────────────────────────────────────────────────────────────────────────────
# Update an alias description in the JSON file
#
# Usage: alias_update_desc <group> <alias> <new_description>
#
# Creates a temporary file, runs jq to modify the value at .[group][alias],
# then moves the temp file back over the original. Prints a success or error.
# ────────────────────────────────────────────────────────────────────────────
alias_update_desc() {
    local group="$1" alias="$2" new_desc="$3"

    if [[ -z ${group} || -z ${alias} || -z ${new_desc} ]]; then
        alias_print red "Usage: alias_update_desc <group> <alias> <new_description>"
        return 1
    fi

    check_json_file || return 1

    local tmpf
    tmpf="$(mktmp)" || {
        alias_print red "Error: Failed to create temporary file"
        return 1
    }

    # Trap to cleanup the tempfile
    trap 'rm -f -- "${tmpf}"' EXIT

    if ! jq --arg group "$group" --arg alias "$alias" --arg desc "$new_desc" \
        '.[$group][$alias] = $desc' "$ALIAS_HELP_FILE" > "$tmpf"; then
        alias_print red "Error: Failed to update JSON (invalid group/alias?)"
        return 1
    fi

    # Use install to ensure proper permissions and atomic replacement
    install -m 644 "$tmpf" "$ALIAS_HELP_FILE"
    trap -- EXIT
    alias_print green "Updated description for '$group::$alias'"
}

# ────────────────────────────────────────────────────────────────────────────
# Simple fuzzy finder wrapper
#
# Usage: alias_fzf [<prompt>]
# If no prompt is given, uses “> ” by default.
# ────────────────────────────────────────────────────────────────────────────
alias_fzf() {
    local prompt="${1:-> }"
    fzf --ansi --prompt="$prompt" --preview="echo {}" --preview-window=down:3:wrap
}

# ────────────────────────────────────────────────────────────────────────────
# Basic fuzzy selector for aliases (returns “group::alias”)
#
# This version shows a preview window that pulls the description
# from the JSON file. Preview is updated each time you move the cursor.
# ────────────────────────────────────────────────────────────────────────────
alias_fzf_alias() {
    check_json_file || return 1

    # Prepare a list of "group::alias"
    jq -r '
        to_entries[] as $group_entry |
        $group_entry.key as $group |
        $group_entry.value | to_entries[] |
        "\($group)::\(.key)"
    ' "$ALIAS_HELP_FILE" | \
        fzf --ansi --prompt="Select alias> " \
            --preview "
                group=\$(echo {} | cut -d ':' -f1)
                alias_name=\$(echo {} | cut -d ':' -f3)
                jq -r --arg g \"\$group\" --arg a \"\$alias_name\" '.[\$g][\$a]' \"$ALIAS_HELP_FILE\"
            " \
            --preview-window=down:3:wrap  
}
