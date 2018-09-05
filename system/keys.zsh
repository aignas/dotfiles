# Pipe my public key to my clipboard.
if [[ ${ZSH_DOTFILES_OS} == "Mac" ]]; then
    alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
else
    alias pubkey="xclip -sel clip < ~/.ssh/id_rsa.pub | echo '=> Public key copied to the clipboard.'"
fi
