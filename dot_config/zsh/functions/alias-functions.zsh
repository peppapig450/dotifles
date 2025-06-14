# ─────────────────────────────────────────────────────────────────────────────
# ~/.config/zsh/functions/alias-functions.zsh
#
# Loads and configures the “alias functions” feature set:
#   - Sources shared helpers (_helpers.zsh) that provide:
#       - ALIAS_HELP_FILE location
#       - alias_print, alias_list_all, alias_list_names, etc.
#   - Adds this directory to $fpath for lazy-loading functions.
#   - Autoloads the following interactive helper functions:
#       - alias-browse-help
#       - alias-help
#       - alias-add-help
#       - _alias_help_complete
# ─────────────────────────────────────────────────────────────────────────────
[[ -o interactive ]] || return 0

# Get the absolute path to this scripts directory
script_dir="${(%):-%x}"
script_dir="${script_dir:A:h}/alias-help"

# Load shared helpers (shared variables and common functions)
source "$script_dir/_helpers.zsh"

# Add this directory to $fpath for autoload-based lazy loading
fpath=("$script_dir" $fpath)

# Autoload all the helpers in the directory, excluding _helpers.zsh
for file in "$script_dir"/[^_]*(.N); do
    autoload -Uz "${file:t}"
done
