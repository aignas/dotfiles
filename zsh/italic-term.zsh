TERMINAL_PRG=${$(ps -p $(ps -p $$ -o ppid=) -o command=):t}

case ${TERMINAL_PRG}+${COLORTERM} in
    gnome-terminal*+*)
        export TERM="xterm-256color-italic"
        export COLORTERM="gnome-terminal"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
    tmux*+gnome-terminal)
        export TERM="screen-256color-italic"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
    tmux*+konsole)
        export TERM="screen-256color-italic"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
    xfce4-terminal*+xfce4-terminal)
        export TERM="xterm-256color-italic"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
esac
