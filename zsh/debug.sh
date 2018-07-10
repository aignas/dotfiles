#!/bin/sh

VERBOSITY=1
if [ $VERBOSITY -ge 1 ]; then 
  start_time="$(date -u +%s.%N)"
fi

function _info() {
  if [ $VERBOSITY -ge 1 ]; then 
    end_time="$(date -u +%s.%N)"
    elapsed="$(bc <<<"$end_time-$start_time")"
    echo "$elapsed [INFO] $@"
  fi
}
function _debug() {
  if [ $VERBOSITY -eq 2 ]; then 
    end_time="$(date -u +%s.%N)"
    elapsed="$(bc <<<"$end_time-$start_time")"
    echo "$elapsed [DEBUG] $@"
  fi
}
