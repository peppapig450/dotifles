# ~/.config/zsh/functions/alias-functions/alias-help.zsh

# ────────────────────────────────────────────────────────────────────────────
# alias-help [alias]
# With no arguments: fuzzy‐search all aliases + descriptions (shows group::alias: description).
# With an argument: print the description for that alias, regardless of group.
# ────────────────────────────────────────────────────────────────────────────
alias-help() {
    if [[ -z "${1}" ]]; then
        alias_list_all | alias_fzf "Alias Help> "
    else
        jq -r --arg alias "${1}" '
            to_entries[] |
            .key as $group |
            .value | select(has($alias)) |
            "\($group)::" + $alias + ": " + .[$alias]
        ' "$ALIAS_HELP_FILE"
    fi
}

# ────────────────────────────────────────────────────────────────────────────
# _alias_help_complete (internal)
# Tab‐completion for alias-help: lists all alias names from every group.
# ────────────────────────────────────────────────────────────────────────────
_alias_help_complete() {
    compadd ${(f)"$(alias_list_names)"}
}
compdef _alias_help_complete alias-help

# ────────────────────────────────────────────────────────────────────────────
# fzf-tab preview for alias-help completion
# Shows the description for each alias in the completion menu.
# ────────────────────────────────────────────────────────────────────────────
zstyle ':completion:*:alias-help:*' fzf-preview \
  'jq -r --arg alias "$word" "to_entries[] | .value | select(has(\$alias)) | .[\$alias]" '"$ALIAS_HELP_FILE"