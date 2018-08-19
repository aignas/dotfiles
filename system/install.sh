if [[ ${ZSH_DOTFILES_OS} == "Darwin" ]]; then
    brew install httpie fd exa ripgrep
elif [[ ${ZSH_DOTFILES_OS} == "ArchLinux" ]]; then
    sudo pacman -Sy --needed httpie python neovim ranger fd exa ripgrep
elif [[ ${ZSH_DOTFILES_OS} == "Debian" ]]; then
    sudo apt-get install httpie ranger
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb
    sudo dpkg -i ripgrep_0.8.1_amd64.deb
fi
