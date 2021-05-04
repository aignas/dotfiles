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
        wireguard

RUN systemctl disable \
        apt-daily-upgrade.timer apt-daily.timer \
        containerd.service \
        dnsmasq.service \
        epmd.service epmd.socket \
        nginx.service \
        openvpn.service \
        unattended-upgrades.service \
        xinetd.service && \
    \
    curl -L recs.pl > /usr/local/bin/recs && chmod a+x /usr/local/bin/recs && \
    curl -o /etc/dropbear-initramfs/authorized_keys \
        https://github.com/aignas.keys && \
    chmod 600 /etc/dropbear-initramfs/authorized_keys && \
    \
    git clone \
        https://github.com/aignas/dotfiles \
        /root/.dotfiles && \
    stow -d /root/.dotfiles ctags tmux vim && \
    \
    apt-file update

COPY overlay/ /

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    \
    sed -i '$a CRYPTSETUP=y' /etc/cryptsetup-initramfs/conf-hook && \
    ln /boot/vmlinuz-* /var/lib/tftpboot/pxelinux/vmlinuz && \
    ln /boot/initrd.img-* /var/lib/tftpboot/pxelinux/initrd.img && \
    ln /boot/memtest86+.bin /var/lib/tftpboot/pxelinux/memtest && \
    ln /usr/lib/syslinux/modules/bios/ldlinux.c32 \
         /usr/lib/syslinux/modules/bios/vesamenu.c32 \
         /usr/lib/syslinux/modules/bios/libcom32.c32 \
         /usr/lib/syslinux/modules/bios/libutil.c32 \
         /usr/lib/PXELINUX/pxelinux.0 \
      /var/lib/tftpboot/pxelinux/ && \
    update-initramfs -v -k all -u && \
    \
    updatedb
