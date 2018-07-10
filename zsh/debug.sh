#!/bin/sh

start_time="$(date -u +%s.%N)"
function _info() {
  _log 1 INFO $@
}
function _debug() {
  _log 2 DEBUG $@
}

function _log() {
  LEVEL=$1; shift
  LEVELSTR=$1; shift
  if [ $VERBOSITY -ge $LEVEL ]; then 
    end_time="$(date -u +%s.%N)"
    elapsed="$(bc <<<"$end_time-$start_time")"
    echo "$elapsed [$LEVELSTR] $@"
  fi
}
