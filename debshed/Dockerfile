FROM debian:buster

# Prep
RUN yes | env DEBIAN_FRONTEND=noninteractive unminimize && \
    \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    \
    ln -fs /usr/share/zoneinfo/Europe/Vilnius /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    \
    DEBIAN_FRONTEND=noninteractive apt-get install \
            -o Dpkg::Options::="--force-confdef" -y \
        sudo git grep zsh

WORKDIR "/root"
COPY . .dotfiles/
env PATH="/root/.dotfiles/bin:$PATH"
RUN dotr --no-push --no-gitconfig && \
    chsh -s $(which zsh) && \
    DEBIAN_FRONTEND=noninteractive apt-get install \
            -o Dpkg::Options::="--force-confdef" -y \
        pandoc texlive-most texlive-lang asciidoc
