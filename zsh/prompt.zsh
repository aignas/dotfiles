# Prompt
# The following are stolen and adapted from @agkozak's wonderful prompt:
# https://github.com/agkozak/agkozak-zsh-prompt, which got this functionality
# was specifically added by @psprint in
# https://github.com/agkozak/agkozak-zsh-prompt/pull/11
#
# This contains just the bare minimum in order to get everything working on my
# machine.

setopt promptsubst

typeset -g VCS_INFO_FD=${RANDOM}
typeset -g GIT_PROMPT_ENABLED=$([ -f "$(command -v git-prompt)" ])

psvar=()
preexec() { psvar[3]=$(_now); }
precmd() {
    setopt LOCAL_OPTIONS NO_IGNORE_BRACES
    async_vcs_info
    psvar[2]=$(_time_it "${psvar[3]:-}")
    psvar[3]=
}

function _now() { date +%s; }
function _time_it() {
    [[ -z $1 ]] && return
    now=$(_now)
    diff=$(( now - $1 ))
    min=$(( diff / 60 ))
    sec=$(( diff % 60 ))
    if (( min > 60 )); then
        echo ">1h"
    elif (( min != 0 && sec != 0 )); then
        echo "${min}m ${sec}s"
    elif (( min != 0 )); then
        echo "${min}m"
    elif (( sec > 2 )); then
        echo "${sec}s"
    fi
}

function async_vcs_info() {
    $GIT_PROMPT_ENABLED || return 0
    pkill git-prompt
    psvar[1]=''

    exec {VCS_INFO_FD}< <(
        git-prompt --print-updates || echo "" # In case of error, clear the prompt
        echo "EOF"
    )
    zle -F "$VCS_INFO_FD" async_vcs_info_callback
}

function async_vcs_info_callback() {
    setopt LOCAL_OPTIONS NO_IGNORE_BRACES

    case ${2:-} in        # process the error, see zshzle -F manpage
        nval) pkill git-prompt && return 0;;    # closed or invalid descrptor
        hup|err) pkill git-prompt && return 0;; # disconnect | any other error
    esac

    local FD="$1" response
    builtin read -u "$FD" response
    if [[ $response == "Err: "* || $response == "EOF" ]]; then
        exec {FD}<&-   # close the file descriptor
        zle -F "${FD}" # Remove any handler associated with this descriptor
        return
    fi

    # Include a space, so that we don't do partial matching we don't want
    if [[ "${psvar[1]} " != "$response *" ]]; then
        psvar[1]="$response"
        zle && { zle reset-prompt; zle -R }
    fi
}

# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
PROMPT='%F{blue}%~%f %{$psvar[1]%}%F{yellow} %{$psvar[2]%}%f
%(?.%F{magenta}.%F{red})%(!.#.$)%f '
