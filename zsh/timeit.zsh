#!/bin/bash

if [[ -n $(command -v gdate) ]]; then
    _now() { gdate +%s%N; }
elif [[ "$(date +%N)" == "N" ]]; then
    _now() { date +%s000; }
else
    _now() { date +%s%N; }
fi

log() {
    [[ ${TIME_PROMPT_DEBUG:-0} == 1 ]] && echo "$@" >>/tmp/time-log.txt
}

non-zero() {
    if (($1 > ${3:-0})); then
        echo "$1$2"
        log "printing '$1$2'"
        return 0
    fi
    return 1
}

typeset -g prompt_prev_time
export prompt_report_time

precmd_functions+=(report_time)

preexec() {
    prompt_prev_time=$(_now)
}

report_time() {
    if [[ ${prompt_prev_time:-0} == 0 ]]; then
        log clearing prompt
        prompt_report_time=
        return
    fi

    log "prompt_prev_time is '$prompt_prev_time'"

    local diff=$((($(_now) - prompt_prev_time) / 1000000))
    prompt_prev_time=
    log "unsetting prompt_prev_time to '$prompt_prev_time'"
    prompt_report_time=$({
        non-zero $((diff / 3600000)) h
        non-zero $((diff % 3600000 / 60000)) m
        if non-zero $((diff % 60000 / 1000)) s 2; then
            non-zero $((diff % 1000)) ms
        fi
    } | xargs)
}
