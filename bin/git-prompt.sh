#!/bin/bash

set -u

# Fall back to a rust implementation if present, which may be installed via a
# package manager.
[[ -f "$(command -v git-prompt)" && "${1:-}" != test ]] && exec git-prompt "$@"

readonly NC="\x1b[0m"
readonly C_RED="\x1b[31m"
readonly C_GREEN="\x1b[32m"
readonly C_YELLOW="\x1b[33m"

print_help() {
    cat <<EOF
Usage
    $0 [--print-updates]
EOF
}

g() {
    git -C "$PWD" "$@"
}

branch() {
    g rev-parse --abbrev-ref HEAD 2>/dev/null
}

ahead-behind() {
    g rev-list --left-right --count "$1...HEAD" |
        awk '$1 {print "\x1b[33m↓\x1b[0m" $1} $2 {print "\x1b[33m↑\x1b[0m" $2}' |
        paste -sd "" -
}

# Stolen from
# https://github.com/magicmonty/bash-git-prompt/blob/master/gitstatus.sh#L54
state() {
    git_dir="$(g rev-parse --git-dir)"
    ret() {
        echo -e "${C_RED}$1${NC}"

        case "${2:-}" in
        apply)
            next=next
            last=last
            ;;
        merge)
            next=msgnum
            last=end
            ;;
        '') return ;;
        esac

        f="$git_dir/rebase-$2/$next"
        [[ -f "$f" ]] && read -r first <"$f"
        f="$git_dir/rebase-$2/$last"
        [[ -f "$f" ]] && read -r second <"$f"

        [[ -n "${first:-}" && -n "${second:-}" ]] && echo "$first/$second"
    }

    if [[ -f "${git_dir}/rebase-merge/interactive" ]]; then
        ret rebase-i merge
    elif [[ -d "${git_dir}/rebase-merge" ]]; then
        ret rebase-m merge
    elif [[ -f "${git_dir}/rebase-apply/rebasing" ]]; then
        ret rebase apply
    elif [[ -f "${git_dir}/rebase-apply/applying" ]]; then
        ret am apply
    elif [[ -d "${git_dir}/rebase-apply" ]]; then
        ret am/rebase apply
    elif [[ -f "${git_dir}/MERGE_HEAD" ]]; then
        ret merge
    elif [[ -f "${git_dir}/CHERRY_PICK_HEAD" ]]; then
        ret cherry-pick
    elif [[ -f "${git_dir}/REVERT_HEAD" ]]; then
        ret revert
    elif [[ -f "${git_dir}/BISECT_LOG" ]]; then
        ret bisect
    fi
}

local-status() {
    staged=0
    unmerged=0
    unstaged=0
    untracked=0

    while IFS= read -r line; do
        case "${line:0:2}" in
        '??') ((untracked++)) ;;
        U? | ?U | DD | AA) ((unmerged++)) ;;
        ?M | ?D) ((unstaged++)) ;;
        '' | ?) ;;
        *) ((staged++)) ;;
        esac
    done <<EOF
$(g status --short)
EOF
    last="$C_GREEN✓$NC"

    if [[ "$unmerged" != 0 ]]; then
        echo -en "$C_RED✖$NC$unmerged"
        last=
    fi
    if [[ "$staged" != 0 ]]; then
        echo -en "$C_GREEN●$NC$staged"
        last=
    fi
    if [[ "$unstaged" != 0 ]]; then
        echo -en "$C_YELLOW✚$NC$unstaged"
        last=
    fi
    if [[ "$untracked" != 0 ]]; then
        echo -n "…"
        last=
    fi
    echo -e $last
}

main() {
    default=origin/master
    case "${1:-}" in
    h | help | -h | --help)
        print_help
        ;;
    '' | --print-updates)
        {
            branch || return
            ahead-behind $default
            local-status
        } | xargs
        ;;
    *)
        print_help
        return 1
        ;;
    esac
}

if [[ "${1:-}" != test ]]; then
    main "$@" || exit 1
    exit 0
fi

FAIL=false
assert() {
    want=$(echo -e "$1")
    shift
    actual="$("$@")"
    if [[ "$want" != "$actual" ]]; then
        FAIL=true
        echo -e "\nFAIL: '$*':\n  '$actual' != '$want'"
        return
    fi
    echo -n .
}

EXPECT=()
RETURN=""
OK=true
g() {
    if [[ "${EXPECT[*]}" != "$*" ]]; then
        FAIL=true
        echo "Failed expectation..."
    fi
    echo -e "$RETURN"
    [ $OK ] || return 1
}

with() {
    RETURN="$1"
    shift
    "$@"
    RETURN=""
}

withfile() {
    file="$1"
    shift
    touch "$file"
    "$@"
    rm "$file"
}

EXPECT=(--help)
with "foo" assert "foo" g --help

EXPECT=(rev-parse --abbrev-ref HEAD)
with foo assert "foo" branch

EXPECT=(rev-list --left-right --count "foo...HEAD")
with "1\t1" assert "${C_YELLOW}↓${NC}1${C_YELLOW}↑${NC}1" ahead-behind foo
with "2\t1" assert "${C_YELLOW}↓${NC}2${C_YELLOW}↑${NC}1" ahead-behind foo
with "2\t0" assert "${C_YELLOW}↓${NC}2" ahead-behind foo
with "0\t1" assert "${C_YELLOW}↑${NC}1" ahead-behind foo

EXPECT=(status --short)
with "\n" assert "$C_GREEN✓$NC" local-status
with "?? myfile\n" assert "…" local-status
with " M myfile\n" assert "${C_YELLOW}✚${NC}1" local-status
with " M myfile\n M second-file\n" assert "$C_YELLOW✚${NC}2" local-status
with "M  myfile\nM  second-file\n" assert "$C_GREEN●${NC}2" local-status

EXPECT=(rev-parse --git-dir)
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT

with "$dir" assert "" state

mkdir -p "$dir/rebase-merge"
with "$dir" assert "${C_RED}rebase-m${NC}" state
echo "5" >"$dir/rebase-merge/msgnum"
echo "7" >"$dir/rebase-merge/end"
with "$dir" assert "${C_RED}rebase-m${NC}\n5/7" state
rm -rf "$dir/rebase-merge"

withfile "$dir/MERGE_HEAD" \
    with "$dir" assert "${C_RED}merge${NC}" state
withfile "$dir/CHERRY_PICK_HEAD" \
    with "$dir" assert "${C_RED}cherry-pick${NC}" state
withfile "$dir/REVERT_HEAD" \
    with "$dir" assert "${C_RED}revert${NC}" state
withfile "$dir/BISECT_LOG" \
    with "$dir" assert "${C_RED}bisect${NC}" state

if [[ $FAIL == true ]]; then
    echo -e "\n\nSome tests failed, check the output above"
    exit 1
fi
echo -e "\n\nOK: Tests passed"