alias visudo='sudo -E EDITOR=$EDITOR visudo'
alias se='sudo -E $EDITOR'
alias vc='$EDITOR ~/.config/nvim/init.vim'
alias push-notes="rclone sync ~/Dropbox/Notes db:Notes"
alias pull-notes="rclone sync db:Notes ~/Dropbox/Notes"
alias todo="$EDITOR +VimFiler \"$HOME/Dropbox (Personal)/_GTD/TODO.md\""
alias worklog="$EDITOR +VimFiler \"$HOME/Dropbox (TRAFI)/Notes/\""
