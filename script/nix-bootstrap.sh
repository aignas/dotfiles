# Entry point of `nix run github:aignas/dotfiles`, see flake.nix. The shebang
# and the shell options are added by writeShellApplication.
#
# Environment variables:
#   DOTFILES_REPO  where to clone the dotfiles from
#   DOTFILES_SRC   where to clone the dotfiles to

repo="${DOTFILES_REPO:-https://github.com/aignas/dotfiles}"
src="${DOTFILES_SRC:-${HOME}/src/github/aignas/dotfiles}"
link="${HOME}/.dotfiles"

if [[ ! -e ${link} ]]; then
    if [[ ! -e ${src} ]]; then
        echo "Cloning ${repo} to ${src}"
        git clone "${repo}" "${src}"
    fi
    ln -sfn "${src}" "${link}"
fi

# Everything else is done by the scripts in the clone, so that the first run
# and subsequent `dotr` runs share the same code path.
export DOTFILES_ROOT="${link}"
exec "${link}/script/bootstrap" "$@"
