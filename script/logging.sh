#!/usr/bin/env bash

if [[ ${DOTFILES_OS} == "Mac" ]]; then
  if [[ -n $(command -v gdate) ]]; then
    now() { gdate +%s%N; }
  else
    now() { date +%s; }
  fi
else
  now() { date +%s%N; }
fi
export DOTFILES_START=${DOTFILES_START:-$(now)}

log () {
  timestamp=$(( ( $(now) - DOTFILES_START ) / 1000 ))
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

debug  (){ [[ -z ${VERBOSE:-} ]] || log DBG "$*"; }
info   (){ log INF "$*"; }
user   (){ log "???" "$*"; }
ok     (){ log OK "$*"; }
fail   (){ log ERR "$*" && exit 1; }
