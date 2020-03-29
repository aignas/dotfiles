#!/bin/bash

set -euo pipefail

export DOTFILES_ROOT="${DOTFILES_ROOT:-"$(git rev-parse --show-toplevel)"}"
cd "${DOTFILES_ROOT}"
# shellcheck source=/dev/null
source "./script/logging.sh"

_vint() {
    info "vint: $*"
    vint --enable-neovim --style-problem --color "$@"
}

_shlint() {
    info "shellcheck: $*"
    shellcheck "$@"

    shfmt="${DOTFILES_ROOT}/tools/shfmt"
    if [[ ! -f $shfmt ]]; then
        echo "using system 'shfmt'"
        shfmt=shfmt
    fi
    info "shfmt: $*"
    "$shfmt" -i 4 -d "$@"
}

_ls() {
    git -C "${DOTFILES_ROOT}" ls-files "$@"
}

_lsh() {
    _grepbang '(usr/bin/env |bin)/(ba|)sh'
}

_grepbang() {
    git -C "${DOTFILES_ROOT}" grep -l -E "^#!/$1" || :
}

main() {
    case "${1:-all}" in
    sh)
        IFS=$'\n' read -r -d '' -a sh_files < <(_lsh && printf '\0')
        _shlint "${sh_files[@]}"
        ;;
    vim)
        IFS=$'\n' read -r -d '' -a vim_files < <(_ls '*.vim' && printf '\0')
        _vint "${vim_files[@]}"
        ;;
    all)
        for i in sh vim; do main "$i"; done
        ;;
    esac
}

main "$@"
