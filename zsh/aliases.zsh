# ZSH related aliases
alias reload!='. ~/.zshrc'

DOTFILES_OS=`uname -s`

# Normal aliases
alias visudo='sudo -E EDITOR=nvim visudo'
#alias ls='ls --color=auto -FX'
alias se='sudo -E'
alias tm='tmux'
alias tmn='tmux neww'
alias gexp='git archive master | tar -x -C'
alias vimconfig='vim ~/.vimrc'
alias nvimconfig='nvim ~/.config/nvim/init.vim'
alias g="git"

alias todo="$EDITOR +VimFiler \"$HOME/Dropbox (Personal)/_GTD/TODO.md\""
alias worklog="$EDITOR +VimFiler \"$HOME/Dropbox (TRAFI)/Notes/\""

if [[ ${DOTFILES_OS} == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias less='less -R'

alias ranger='if [ -z "$RANGER_LEVEL" ]; then ranger; else exit; fi'
# Have only one fzf-fs session running
alias f='if [[ -z ${FZF_FS_DEFAULT_OPTS_OLD+x} ]]; then fzf-fs; else exit; fi'

if [[ ${DOTFILES_OS} != "Darwin" ]]; then
    PKGBUILD_DIR="${HOME}/src/aur"

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
fi
