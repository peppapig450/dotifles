# ls-aliases.zsh
# Aliases for listing files and directories using eza.

if ! (( $+commands[eza] )); then
  print "ls-aliases.zsh: eza not found on path. Please install eza first." >&2
  return 1
fi

# Basic replacements
alias ls='eza --group-directories-first --icons=auto'      # basic listing with dirs first
alias la='ls -a'                                           # show hidden too
alias ll='ls -l --smart-group'                             # long list
alias lla='ll -a'                                          # long list, all files
alias llh='ll --header'                                    # long list with header
alias llha='llh -a'                                        # long list with header, all files

# Tree view
alias lt='ls -T'                                           # tree view
alias ltg='lt --git-ignore'                                # tree view, respect .gitignore
alias lta='lt -a'                                          # tree view all files
alias ltag='lta --git-ignore'                              # tree view, all files, respect .gitignore

# Recursion
alias lr='ls -R'
alias lra='lr -a'

# One entry per line
alias lone='ls -1'
alias lonea='lone -a'

# Git aware
alias lgit='la --git --header'
alias lgittree='lt --git'

# Directory only / file only
alias ldirs='ls -D --show-symlinks'
alias lfiles='ls -f --show-symlinks'

# Fancy sorting
alias lsize='ls -l --sort=size'
alias ltime='ls -l --sort=modified'
alias ltype='ls -l --sort=type'
alias lname='ls -l --sort=name'
alias lext='ls -l --sort=extension'
function ls-sort() { ls -l --sort="$1" "${@:2}" ; }
# Usage: ls-sort size [-a]

# Extended attributes, security context, inode
function lextend()  { ls -l --extended "$@" ; }
function lctx()     { ls -l --context "$@" ; }
function linode()   { ls -l --inode "$@" ; }

# Colorful power listings
function lcolor()   { ls -l --color=scale "$@" ; }
function lbig()     { ls -l --binary "$@" ; }
function lbytes()   { ls -l --bytes "$@" ; }

# Absolute paths
alias labs='ls -l --absolute=follow'

# Hard links
alias llinks='ls -l -H'

# Mounts info (macOS/BSD/Linux)
alias lmount='ls -l -M'

# Permissions in octal
alias loctal='ls -l -o'

# Minimalist (no details)
alias lno='ls -l --no-permissions --no-filesize --no-user --no-time'
alias lano='ls -la --no-permissions --no-filesize --no-user --no-time'

# Change timestamp field
alias laccess='ls -l -u'        # access time
alias lcreate='ls -l -U'        # creation time
alias lchange='ls -l --changed' # changed time

# Show it all
alias lall='ls -laa --extended --mounts --numeric --time-style full-iso --total-size --octal-permissions --group -H -l -X --follow-symlinks --absolute follow --header'

function dls() {
  doas eza --group-directories-first --icons=auto "$@"
}
