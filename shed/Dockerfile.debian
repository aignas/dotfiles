FROM debian:buster

# Prep
RUN yes | env DEBIAN_FRONTEND=noninteractive && \
    \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    \
    ln -fs /usr/share/zoneinfo/Europe/Vilnius /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    \
    DEBIAN_FRONTEND=noninteractive apt-get install \
            -o Dpkg::Options::="--force-confdef" -y \
        sudo git grep zsh

WORKDIR "/root"
COPY . .dotfiles/
env PATH="/root/.dotfiles/bin:$PATH"
RUN dotr --no-push --no-gitconfig
RUN chsh -s $(which zsh)
RUN DEBIAN_FRONTEND=noninteractive apt-get install \
            -o Dpkg::Options::="--force-confdef" -y \
        pandoc texlive-full asciidoc
