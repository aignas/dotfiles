if [[ ${ZSH_DOTFILES_OS} == "Mac" ]]; then
    brew install python3 httpie fd exa ripgrep htop ranger bat
    brew cask install alacritty
elif [[ ${ZSH_DOTFILES_OS} == "ArchLinux" ]]; then
    sudo pacman -Sy --needed \
        httpie \
        python \
        neovim \
        ranger \
        fd exa ripgrep bat \
        alacritty \
        htop \
        dep \
        skk-jisyo
fi
