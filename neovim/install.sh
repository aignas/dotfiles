set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

NEOVIM_LOCAL="${HOME}/.local/share/nvim"
VIMPLUG_DIR="${NEOVIM_LOCAL}/plugged"
NEOVIM_VENV="${NEOVIM_LOCAL}/venv"

pyenv() {
  rm -rf "NEOVIM_VENV*"
  python3 -m venv "${NEOVIM_VENV}"
  "${NEOVIM_VENV}/bin/pip" -q \
    install --upgrade \
    neovim pip setuptools
  success "python venv: ${NEOVIM_VENV}"
}

vimplug() {
  if [ ! -d "${VIMPLUG_DIR}" ]; then
    info "Installing vim-plug from scratch"
    mkdir -p "${NEOVIM_LOCAL}/plugged"
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  success "vim-plug: ${VIMPLUG_DIR}"
}

vimplug-update() {
  nvim --headless \
    +PlugUpgrade \
    +PlugInstall \
    +PlugUpdate \
    +PlugClean \
    +qa!
  success "vim-plug plugins installed"
}

backupdir() {
  readonly backup_dir="${NEOVIM_LOCAL}/backups"
  mkdir -p "${backup_dir}"
  success "backup-dir: ${backup_dir}"
}

skk() {
  target="${NEOVIM_LOCAL}/skk/SKK-JISYO.L"
  rm -rf "${target}"{,.gz}
  curl \
    --create-dirs \
    --output "${target}.gz" \
    https://skk-dev.github.io/dict/SKK-JISYO.L.gz
  gunzip "${target}.gz"
  success "downloading SKK-JISYO.L"
}

pyenv
vimplug
vimplug-update
backupdir
skk
