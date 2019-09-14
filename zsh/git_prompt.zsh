# The following is adapted from @agkozak's wonderful prompt:
# https://github.com/agkozak/agkozak-zsh-prompt, which got this functionality
# was specifically added by @psprint in
# https://github.com/agkozak/agkozak-zsh-prompt/pull/11
#
# This contains just the bare minimum in order to get everything working on my
# machine.

CMD=git-prompt.sh
[[ -f "$(command -v git-prompt)" ]] && CMD=git-prompt
DEBUG_GIT_PROMPT="${DEBUG_GIT_PROMPT:-false}"
readonly _log_file="/tmp/git-prompt-log.txt"

_log() {
    [[ "${DEBUG_GIT_PROMPT}" != "false" ]] && echo "[$(date +%X.%N)]: $*" >> "$_log_file"
}

precmd_functions=(async_vcs_info)
typeset -g prompt_git_status
typeset -g VCS_INFO_FD=${RANDOM}
function async_vcs_info() {
    # Cleanup previously running processes and close the descriptors.
    # Disregard the errors
    2>/dev/null 1>/dev/null {
        _log killing old cmd
        exec {VCS_INFO_FD}<&-
        zle -F "${VCS_INFO_FD}"
    }

    exec {VCS_INFO_FD}< <(
        _log spawning bg job
        $CMD --print-updates 2>&1 || :
        echo "EOF"
    )

    _log starting callback
    zle -F "$VCS_INFO_FD" async_vcs_info_callback
}

function async_vcs_info_callback() {
    setopt LOCAL_OPTIONS NO_IGNORE_BRACES

    # process the error, see zshzle -F manpage
    case ${2:-} in
        nval)
            _log killing "'$CMD'" due to invalid descriptor
            pkill $CMD
            return
            ;;
        err)
            _log killing "'$CMD'" due to disconnect or some error: "$2"
            pkill $CMD
            return
            ;;
    esac

    local FD="$1" response
    builtin read -u "$FD" response
    case "$response" in
        "Err: "* | "EOF")
            _log closing fd and removing handler due to "$response"
            exec {FD}<&-   # close the file descriptor
            zle -F "${FD}" # Remove any handler associated with this descriptor
            return
            ;;
    esac

    _log "current prompt value: '$prompt_git_status'"
    _log "got update: '$response'"

    # Include a space, so that we don't do partial matching we don't want
    [[ "${prompt_git_status} " == "$response "* ]] && return
    _log "redrawing..."

    prompt_git_status="$response"
    zle reset-prompt
    zle -R
}
