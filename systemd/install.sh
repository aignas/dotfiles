#!/bin/bash
#
# A small hack to install customizations for some of the user systemd services.
# It seems that if I put the symlinks to this dir, systemd won't detect changes
# to the service files.

dirs=(
    spotifyd.service.d
)

dst="${HOME}/.config/systemd/user/"

for src in "$(dirname "$0")/${dirs[@]}"; do
    rsync --recursive --verbose --mkpath "$src" "$dst"
done

exa -T $dst
