#!/bin/zsh

typeset -g prompt_report_time
typeset -g prompt_prev_time

function _now() { date +%s; }

precmd_functions+=(report_time)

preexec() {
    prompt_prev_time=$(_now)
}

function report_time() {
    if [[ ${prompt_prev_time:-0} == 0 ]]; then
        prompt_report_time=""
        return
    fi

    local diff=$(($(_now) - prompt_prev_time))
    local hr=$((diff / 3600))
    local min=$((diff % 3600 / 60))
    local sec=$((diff % 60))

    prompt_prev_time=0
    if ((hr > 0)); then prompt_report_time+="${hr}h"; fi
    if ((min > 0)); then prompt_report_time+=" ${min}m"; fi
    if ((sec >= 3)); then prompt_report_time+=" ${sec}s"; fi
}
