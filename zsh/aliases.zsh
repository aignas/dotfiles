# ZSH related aliases
alias reload!='. ~/.zshrc'

DOTFILES_OS=`uname -s`
PKGBUILD_DIR="${HOME}/src/aur"

# Normal aliases
alias visudo='sudo -E EDITOR=vim visudo'
#alias ls='ls --color=auto -FX'
alias se='sudo -E'
alias tm='tmux'
alias tmn='tmux neww'
alias gexp='git archive master | tar -x -C'
alias vim='nvim'
alias neovim='nvim'
alias vimconfig='nvim ~/.config/nvim/init.vim'

if [[ ${DOTFILES_OS} == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias less='less -R'

alias ranger='if [ -z "$RANGER_LEVEL" ]; then ranger; else exit; fi'

function fontadd () {
    cp $@ ~/.fonts/
}

function aurd () {
    mkdir -p ${PKGBUILD_DIR}
    for pkg in $@; do
        git clone ssh://aur@aur.archlinux.org/$pkg.git/ ${PKGBUILD_DIR}/$pkg
    done
}

function aurb () {
    mkdir -p ${PKGBUILD_DIR}
    # Download everything first
    aurd $@

    for pkg in $@; do
        pushd ${PKGBUILD_DIR}/$pkg
        makepkg -si
        popd # ${PKGBUILD_DIR}/$pkg
    done
}
