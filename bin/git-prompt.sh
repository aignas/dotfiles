#!/bin/bash
set -u

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
        awk '$1 {print "↓" $1} $2 {print "↑" $2}' |
        paste -sd "" -
}

# Stolen from
# https://github.com/magicmonty/bash-git-prompt/blob/master/gitstatus.sh#L54
state() {
    git_dir="$(g rev-parse --git-dir)"

    __git_prompt_read() {
        local f="${1}"
        shift
        [[ -r "${f}" ]] && read -r "${@}" <"${f}"
    }

    state=""
    step=""
    total=""
    if [[ -d "${git_dir}/rebase-merge" ]]; then
        __git_prompt_read "${git_dir}/rebase-merge/msgnum" step
        __git_prompt_read "${git_dir}/rebase-merge/end" total
        if [[ -f "${git_dir}/rebase-merge/interactive" ]]; then
            state="rebase-i"
        else
            state="rebase-m"
        fi
    elif [[ -d "${git_dir}/rebase-apply" ]]; then
        __git_prompt_read "${git_dir}/rebase-apply/next" step
        __git_prompt_read "${git_dir}/rebase-apply/last" total
        if [[ -f "${git_dir}/rebase-apply/rebasing" ]]; then
            state="rebase"
        elif [[ -f "${git_dir}/rebase-apply/applying" ]]; then
            state="am"
        else
            state="am/rebase"
        fi
    elif [[ -f "${git_dir}/MERGE_HEAD" ]]; then
        state="merge"
    elif [[ -f "${git_dir}/CHERRY_PICK_HEAD" ]]; then
        state="cherry-pick"
    elif [[ -f "${git_dir}/REVERT_HEAD" ]]; then
        state="revert"
    elif [[ -f "${git_dir}/BISECT_LOG" ]]; then
        state="bisect"
    fi

    if [[ -n "${step}" ]] && [[ -n "${total}" ]]; then
        echo "${state} ${step}/${total}"
    else
        echo "${state}"
    fi
}

local-status() {
    untracked=0
    staged=0
    unstaged=0
    unmerged=0

    while IFS= read -r line; do
        s="${line:0:2}"
        case $s in
            U?|?U|DD|AA)((unmerged++));;
            "??")       ((untracked++));;
            ?M|?D)      ((unstaged++));;
            ''| ?)      ;;
            *)          ((staged++));;
        esac
    done << EOF
$(g status --short)
EOF
    clean=true
    if [[ "$unmerged" != 0 ]]; then
        echo -n "✖$unmerged"
        clean=false
    fi
    if [[ "$staged" != 0 ]]; then
        echo -n "●$staged"
        clean=false
    fi
    if [[ "$unstaged" != 0 ]]; then
        echo -n "✚$unstaged"
        clean=false
    fi
    if [[ "$untracked" != 0 ]]; then
        echo -n "…"
        clean=false
    fi
    if [ $clean = true ]; then echo "✓"; else echo; fi
}

main() {
    default=origin/master
    case "${1:-}" in
        h|help|-h|--help)
            print_help
            ;;
        --print-updates)
            current=$(branch) || {
                echo
                return
            }
            echo "$current"
            current=$({
                echo "$current"
                ahead-behind $default
            } | xargs)
            echo "$current"
            {
                echo "$current"
                local-status
            } | xargs
            ;;
        '')
            {
                branch || return
                ahead-behind $default
                local-status
            } | xargs
            ;;
        *)
            return 1
            ;;
    esac
}

if [[ "${1:-}" != test ]]; then
    main "$@" && exit 0
    exit 1
fi

FAIL=false

assert() {
    want="$1";shift
    actual="$("$@")"
    if [[ "$want" != "$actual" ]]; then
        FAIL=true
        echo "FAIL: '$*': '$actual' != '$want'"
        return 1
    fi
    echo "  OK: '$*': '$want'"
}

require() {
    want="$1";shift
    actual="$("$@")"
    if [[ "$want" != "$actual" ]]; then
        FAIL=true
        echo "FAIL: '$want' != '$actual': '$*'"
        exit 1
    fi
    echo "  OK: '$want' == '$*'"
}

echo "Running $0 tests..."

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
    RETURN="$1"; shift
    "$@"
    RETURN=""
}

withfile() {
    file="$1"; shift
    touch "$file"
    "$@"
    rm "$file"
}

EXPECT=(--help)
with "foo" assert "foo" g --help

EXPECT=(rev-parse --abbrev-ref HEAD)
with foo assert "foo" branch

EXPECT=(rev-list --left-right --count "foo...HEAD")
with "1\t1" assert "↓1↑1" ahead-behind foo
with "2\t1" assert "↓2↑1" ahead-behind foo
with "2\t0" assert "↓2" ahead-behind foo
with "0\t1" assert "↑1" ahead-behind foo

EXPECT=(status --short)
with "\n" assert "✓" local-status
with "?? myfile\n" assert "…" local-status
with " M myfile\n" assert "✚1" local-status
with " M myfile\n M second-file\n" assert "✚2" local-status
with "M  myfile\nM  second-file\n" assert "●2" local-status

EXPECT=(rev-parse --git-dir)
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT

with "$dir" assert "" state

mkdir -p "$dir/rebase-merge"
with "$dir" assert "rebase-m" state
echo "5" > "$dir/rebase-merge/msgnum"
echo "7" > "$dir/rebase-merge/end"
with "$dir" assert "rebase-m 5/7" state
rm -rf "$dir/rebase-merge"
withfile "$dir/MERGE_HEAD" \
    with "$dir" assert "merge" state
withfile "$dir/CHERRY_PICK_HEAD" \
    with "$dir" assert "cherry-pick" state
withfile "$dir/REVERT_HEAD" \
    with "$dir" assert "revert" state
withfile "$dir/BISECT_LOG" \
    with "$dir" assert "bisect" state

if [ $FAIL = true ]; then
    echo ""
    echo "Some tests failed, check the output above"
    exit 1
fi
echo "  OK: Tests passed"
