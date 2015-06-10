TERMINAL_PRG=${$(ps -p $(ps -p $$ -o ppid=) -o command=):t}

COLOR_VALUE="-256-color-italic"
# COLOR_VALUE=""

case ${TERMINAL_PRG}+${COLORTERM} in
    gnome-terminal*+*)
        export TERM="xterm$COLOR_VALUE"
        export COLORTERM="gnome-terminal"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
    tmux*+gnome-terminal)
        export TERM="screen$COLOR_VALUE"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
    tmux*+konsole)
        export TERM="screen$COLOR_VALUE"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
    xfce4-terminal*+xfce4-terminal)
        export TERM="xterm$COLOR_VALUE"
        export NVIM_TUI_ENABLE_TRUE_COLOR=1
        ;;
esac
