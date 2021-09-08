#!/bin/bash

set -euo pipefail

_info() {
    echo $@ >&2
}

_ps1() {
    _info -ne "\033[01;34m\$ \033[00m"
}

_echocmd() {
    _info "$(_ps1) $*"
}

run() {
    _echocmd $@
    $@
}

info() {
    _info ""
    _info -e "\033[01;34m# Next step:\033[00m $*"
}

pause() {
    info $@
    read -p "Continue (Y/n)?" choice
    case "$choice" in
    '' | y | Y) return 0 ;;
    esac

    echo "Skipping..."
    return 1
}
