FROM archlinux/base

# Prep
RUN ln -fs /usr/share/zoneinfo/Europe/Vilnius /etc/localtime

# Rank mirrors before doing majority of work
RUN pacman -Sy --noconfirm pacman-contrib && \
    curl -s "https://www.archlinux.org/mirrorlist/?country=FR&country=GB&country=LT&country=US&protocol=https&use_mirror_status=on" | \
        sed -e 's/^#Server/Server/' -e '/^#/d' | \
        rankmirrors -n 5 - | \
        tee /etc/pacman.d/mirrorlist

# Bootstrap using the same scripts as my dotfiles and install extras
RUN pacman -S --noconfirm sudo git && \
    git clone --recursive https://github.com/aignas/dotfiles.git ${HOME}/.dotfiles && \
    # TODO @aignas (2019-06-12): when I change dotr to install the toolshed,
    # add a CLI option to not do that
    "${HOME}/.dotfiles/bin/dotr" --no-push --no-gitconfig && \
    chsh -s $(which zsh)

# Install extra tools
RUN pacman -S --noconfirm \
        pandoc texlive-most texlive-lang asciidoc

env SHELL="${HOME}/.dotfiles/bin:$PATH"
env PATH="/root/.dotfiles/bin:$PATH"
