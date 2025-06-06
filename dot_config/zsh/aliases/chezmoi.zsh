# chezmoi.zsh
# Aliases to simplify and speed up common chezmoi operations

alias cz='chezmoi'
alias czcd='cz cd'
alias czd='cz diff'
alias cza='cz apply'
alias czea='cz edit --apply'
alias czaa='cz add'
alias czr='cz re-add'
alias czup='cz update'
alias czupup='cz upgrade'
alias czgen='cz generate'
alias czs='cz status'
alias czrm='cz forget'
alias czdoc='cz doctor'
alias czi='cz ignored'
alias czh='cz help'
alias czx='cz execute-template'
alias czm='cz managed'
alias czt='cz managed | tree --fromfile .'

# Function to pass through git commands to chezmoi-managed repo
czg() {
    chezmoi git -- "$@"
}