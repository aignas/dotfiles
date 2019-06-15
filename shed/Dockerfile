FROM archlinux/base

# Prep
RUN ln -fs /usr/share/zoneinfo/Europe/Vilnius /etc/localtime

# Rank mirrors before doing majority of work
RUN pacman -Sy --noconfirm sudo pacman-contrib grep git zsh && \
    curl -s "https://www.archlinux.org/mirrorlist/?country=FR&country=GB&country=LT&country=US&protocol=https&use_mirror_status=on" | \
        sed -e 's/^#Server/Server/' -e '/^#/d' | \
        rankmirrors -n 5 - | \
        tee /etc/pacman.d/mirrorlist

WORKDIR "/root"
COPY . .dotfiles/
env PATH="/root/.dotfiles/bin:$PATH"
RUN dotr --no-push --no-gitconfig && \
    pacman -S --noconfirm \
        pandoc texlive-most texlive-lang asciidoc
