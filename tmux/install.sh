#!/usr/bin/env bash

DIR=$HOME/.tmux/plugins/tpm
if [[ -d "$DIR" ]]; then
  git -C "${DIR}" fetch origin
  git -C "${DIR}" reset --hard origin/master
else
  git clone \
    --depth=1 \
    --branch=master \
    https://github.com/tmux-plugins/tpm "$DIR"
fi

"$DIR/bin/clean_plugins"
"$DIR/bin/update_plugins" all
"$DIR/bin/install_plugins"
