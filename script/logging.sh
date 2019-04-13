#!/usr/bin/env bash

now() {
  date +%s%N
}

time_zero=$(now)

log () {
  timestamp=$(( ( $(now) - time_zero ) / 1000 ))
  timestamp="$(( timestamp / 1000 )).$(( timestamp % 1000))"
  local level=$1; shift
  case "$level" in
    INF|"???")
      level=$(printf "\033[0;33m%3s\033[0m" "$level")
      ;;
    OK)
      level=$(printf "\033[0;32m%3s\033[0m" "$level")
      ;;
    ERR)
      level=$(printf "\033[0;31m%3s\033[0m" "$level")
      ;;
    *)
      level=$(printf "%3s" "$level")
      ;;
  esac
  printf "%10.3f [%s] %s\n" "$timestamp" "$level" "$*"
}

debug  (){ [[ -z ${VERBOSE} ]] || log DBG "$*"; }
info   (){ log INF "$*"; }
user   (){ log "???" "$*"; }
success(){ log OK "$*"; }
fail   (){ log ERR "$*" && exit 1; }
