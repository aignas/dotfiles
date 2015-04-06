# ZSH related aliases
alias reload!='. ~/.zshrc'

# Normal aliases
alias visudo='sudo -E EDITOR=vim visudo'
alias ls='ls --color=auto -FX'
alias se='sudo -E'
alias tm='tmux'
alias gexp='git archive master | tar -x -C'

function fontadd () {
    cp $@ ~/.fonts/
}
