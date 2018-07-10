# ZSH related aliases
alias reload!='. ~/.zshrc'

DOTFILES_OS=`uname -s`

# Normal aliases
alias visudo='sudo -E EDITOR=$EDITOR visudo'
alias se='sudo -E'
alias vc='$EDITOR ~/.config/nvim/init.vim'
alias g="git"
alias push-notes="rclone sync ~/Dropbox/Notes db:Notes"
alias pull-notes="rclone sync db:Notes ~/Dropbox/Notes"
alias todo="$EDITOR +VimFiler \"$HOME/Dropbox (Personal)/_GTD/TODO.md\""
alias worklog="$EDITOR +VimFiler \"$HOME/Dropbox (TRAFI)/Notes/\""
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias grep='grep --color=auto'
alias less='less -R'
alias ranger='if [ -z "$RANGER_LEVEL" ]; then ranger; else exit; fi'
