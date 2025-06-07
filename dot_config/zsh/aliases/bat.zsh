# bat.zsh
# Aliases to use bat as a replacement for cat and for fzf previews.

alias cat='bat'
alias fzfcat='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
alias catless='cat --style=plain --paging=always'
alias cathead='cat --style=header'
alias catgrid='cat --style=grid'
alias catgit='cat --style=changes'
alias catd='cat --style=default'
alias catfull='cat --style=full'