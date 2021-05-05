# Based on Debian testing
FROM buildpack-deps:testing

RUN apt-get update && \
    \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-file \
        build-essential \
        stow \
        busybox \
        clang \
        cloc \
        cowbuilder \
        cowsay \
        dropbear-initramfs \
        gdb \
        golang \
        graphicsmagick \
        graphviz \
        htop \
        info \
        iotop \
        jq \
        less \
        lsof \
        lua5.2 \
        lua5.2-doc \
        lvm2 \
        lynx \
        lz4 \
        man-db \
        manpages \
        manpages-dev \
        neovim \
        pandoc \
        parallel \
        parted \
        protobuf-compiler \
        redir \
        rsync \
        sdparm \
        shellcheck \
        sloccount \
        strace \
        sudo \
        tcpdump \
        telnet \
        texlive \
        texlive-lang-european \
        texlive-latex-extra \
        tmux \
        tree \
        tsocks \
        tzdata \
        udev \
        unzip \
        valgrind \
        wait-for-it \
        xinetd \
        youtube-dl \
        zsh \
        wireguard && \
    \
    systemctl disable \
        apt-daily-upgrade.timer apt-daily.timer \
        unattended-upgrades.service \
        xinetd.service && \
    \
    apt-file update

RUN git clone \
        https://github.com/aignas/dotfiles \
        /root/.dotfiles && \
    stow -d /root/.dotfiles tmux zsh && \
    mkdir -p /root/.config && \
    stow -d /root/.dotfiles -t /root/.config neovim

COPY overlay/ /
