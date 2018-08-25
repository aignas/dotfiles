function profile() {
    echo "PROFILE: $@"
}
function rebundle!() {
    antibody bundle < ${ZSH_DOTFILES}/zsh/zsh_plugins.txt > ${ZSH_DOTFILES}/zsh/plugins.sh
}
alias reload!='. ~/.zshrc'
alias g="git"
if $(x &>/dev/null)
then
  alias ls='x'
  alias ll='x -l'
  alias la='x -A'
fi
alias grep='grep --color=auto'
alias less='less -R'
alias ranger='if [ -z "$RANGER_LEVEL" ]; then ranger; else exit; fi'
