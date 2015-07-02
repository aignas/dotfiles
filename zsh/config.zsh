# This is included in my dot files
eval `dircolors ${HOME}/.dir_colors`
export CLICOLOR=true

fpath=($ZSH_DOTFILES/functions $fpath)

autoload -U $ZSH_DOTFILES/functions/*(:t)

# ZSH options {{{
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BG_NICE               # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS            # allow functions to have local options
setopt LOCAL_TRAPS              # allow functions to have local traps
setopt HIST_VERIFY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

setopt APPEND_HISTORY           # adds history
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt EXTENDED_HISTORY         # add timestamps to history

# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
# }}}

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

# Key bindings {{{
bindkey -v      # vim keybinding mode
# Set some bindings
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey '^?'    backward-delete-char
bindkey '^[OH~' vi-beginning-of-line
bindkey '^[OF~' vi-end-of-line
bindkey '^[[3~' vi-delete-char
bindkey '^[3;5~' vi-delete-char
bindkey '^[.'   insert-last-word
# }}}

# {{{ Manual pages
#     - colorize, since man-db fails to do so
export LESS_TERMCAP_mb=$'\E[01;31m'   # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'   # begin bold
export LESS_TERMCAP_me=$'\E[0m'       # end mode
export LESS_TERMCAP_se=$'\E[0m'       # end standout-mode
export LESS_TERMCAP_so=$'\E[1;33;40m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'       # end underline
export LESS_TERMCAP_us=$'\E[1;32m'    # begin underline
# }}}

# vim: foldmethod=marker
