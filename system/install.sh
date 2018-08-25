if [[ ${ZSH_DOTFILES_OS} == "Mac" ]]; then
    brew install python3 httpie fd exa ripgrep htop ranger task timewarrior
elif [[ ${ZSH_DOTFILES_OS} == "ArchLinux" ]]; then
    sudo pacman -Sy --needed httpie python neovim ranger fd exa ripgrep htop task timewarrior
elif [[ ${ZSH_DOTFILES_OS} == "Debian" ]]; then
    sudo apt-get install httpie ranger
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb
    sudo dpkg -i ripgrep_0.8.1_amd64.deb
fi
