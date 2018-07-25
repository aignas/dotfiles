# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

if [[ ${ZSH_DOTFILES_OS} == "ArchLinux" ]]; then
    PKGBUILD_DIR="${HOME}/src/aur"

    function aurd () {
        mkdir -p ${PKGBUILD_DIR}
        for pkg in $@; do
            git clone https://aur.archlinux.org/$pkg.git/ ${PKGBUILD_DIR}/$pkg
        done
    }

    function aurb () {
        mkdir -p ${PKGBUILD_DIR}
        # Download everything first
        aurd $@

        for pkg in $@; do
            pushd ${PKGBUILD_DIR}/$pkg
            makepkg -si
            popd # ${PKGBUILD_DIR}/$pkg
        done
    }
fi

alias x=exa

