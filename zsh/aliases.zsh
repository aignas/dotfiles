# ZSH related aliases
alias reload!='. ~/.zshrc'

# Normal aliases
alias visudo='sudo -E EDITOR=vim visudo'
#alias ls='ls --color=auto -FX'
alias se='sudo -E'
alias tm='tmux'
alias tmn='tmux neww'
alias gexp='git archive master | tar -x -C'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias less='less --color=auto'

function fontadd () {
    cp $@ ~/.fonts/
}

function aurd () {
    git clone https://aur4.archlinux.org/$1.git/ ${HOME}/src/aur/$1
}

function aurb () {
    aurd $1 && cd ${HOME}/src/aur/$1 && makepkg -si && cd -
}
