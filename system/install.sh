if [[ ${ZSH_DOTFILES_OS} == "Darwin" ]]; then
    brew install httpie
elif [[ ${ZSH_DOTFILES_OS} == "ArchLinux" ]]; then
    sudo pacman -Sy --needed httpie python neovim ranger
elif [[ ${ZSH_DOTFILES_OS} == "Debian" ]]; then
    sudo apt-get install httpie ranger
fi
