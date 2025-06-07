# ~/.config/zsh/functions/alias-functions/alias-add-help.zsh

# alias-add-help
# Interactively select an alias to edit its description.
# Uses alias_fzf_alias to pick "group::alias" and alias_update_desc to update.
alias-add-help() {
    local selection group alias desc new_desc

    # Pick "group::alias" via fuzzy finder (with preview of the current description).
    selection="$(alias_fzf_alias)"
    [[ -z "${selection}" ]] && return 1

    group="${selection%%::*}"
    alias="${selection##*::}"

    # Fetch existing description (if any)
    desc="$(jq -r --arg group "$group" --arg alias "$alias" '.[$group][$alias] // ""' "$ALIAS_HELP_FILE")"

    alias_print yellow "Current description for $alias: %F{cyan}$desc%f"
    vared -p "New description (leave blank to keep): " new_desc
    [[ -z "${new_desc}" ]] && new_desc="${desc}"

    alias_update_desc "$group" "$alias" "$new_desc"
}

