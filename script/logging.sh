#!/usr/bin/env sh

info () {
  printf "  [ \033[00;34m..\033[0m ] %s\n" "$@"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] %s " "$@"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$@"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$@"
  echo ''
  exit
}
