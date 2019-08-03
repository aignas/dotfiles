# The following is adapted from @agkozak's wonderful prompt:
# https://github.com/agkozak/agkozak-zsh-prompt, which got this functionality
# was specifically added by @psprint in
# https://github.com/agkozak/agkozak-zsh-prompt/pull/11
#
# This contains just the bare minimum in order to get everything working on my
# machine.

[ -f "$(command -v git-prompt)" ] && precmd_functions=(async_vcs_info)
typeset -g prompt_git_status
function async_vcs_info() {
    typeset VCS_INFO_FD=${RANDOM}
    exec {VCS_INFO_FD}< <(
        pkill git-prompt
        git-prompt --print-updates || :
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
    if [[ "${prompt_git_status} " != "$response *" ]]; then
        prompt_git_status="$response"
        zle && { zle reset-prompt; zle -R }
    fi
}
