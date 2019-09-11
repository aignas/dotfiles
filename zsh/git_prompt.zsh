# The following is adapted from @agkozak's wonderful prompt:
# https://github.com/agkozak/agkozak-zsh-prompt, which got this functionality
# was specifically added by @psprint in
# https://github.com/agkozak/agkozak-zsh-prompt/pull/11
#
# This contains just the bare minimum in order to get everything working on my
# machine.

CMD=git-prompt.sh
[[ -f "$(command -v git-prompt)" ]] && CMD=git-prompt

precmd_functions=(async_vcs_info)
typeset -g prompt_git_status
typeset -g VCS_INFO_FD=${RANDOM}
function async_vcs_info() {
    # Cleanup previously running processes and close the descriptors.
    # Disregard the errors
    2>/dev/null 1>/dev/null {
        exec {VCS_INFO_FD}<&-
        zle -F "${VCS_INFO_FD}"
    }

    exec {VCS_INFO_FD}< <(
        $CMD --print-updates 2>&1 || :
        echo "EOF"
    )

    zle -F "$VCS_INFO_FD" async_vcs_info_callback
}

function async_vcs_info_callback() {
    setopt LOCAL_OPTIONS NO_IGNORE_BRACES

    # process the error, see zshzle -F manpage
    case ${2:-} in
        nval)    pkill $CMD && return;; # closed or invalid descrptor
        hup|err) pkill $CMD && return;; # disconnect | any other error
    esac

    local FD="$1" response
    builtin read -u "$FD" response
    case "$response" in
        "Err: "* | "EOF")
            exec {FD}<&-   # close the file descriptor
            zle -F "${FD}" # Remove any handler associated with this descriptor
            return
            ;;
    esac

    # Include a space, so that we don't do partial matching we don't want
    if [[ "${prompt_git_status} " != "$response *" ]]; then
        prompt_git_status="$response"
        zle && { zle reset-prompt; zle -R }
    fi
}
