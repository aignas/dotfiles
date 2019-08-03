function _now() { date +%s; }
preexec() { _last_ts=$(_now); }
function prompt_report_time() {
    [[ -z ${_last_ts:-} ]] && return

    diff=$(( $(_now) - _last_ts ))
    hr=$((diff/3600))
    min=$((diff%3600/60))
    sec=$((diff% 60))
    if (( hr > 0 )); then printf ' %dh' $hr; fi
    if (( min > 0 )); then printf ' %dm' $min; fi
    if (( sec >= 3 )); then printf ' %ds' $sec; fi
}
