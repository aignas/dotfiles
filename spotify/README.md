# Setup instructions for SpotifyD

```
secret-tool store --label='daemons' application rust-keyring service spotifyd username <username>
systemctl --user start spotifyd.service
systemctl --user enable spotifyd.service
```

# Enabling 'playerctl' integration

The following commands were needed in order to setup the loading of my config
correctly. However, `restow` should symlink the required modifications to any
system.

```
systemctl --user edit spotifyd.service
systemctl --user daemon-reload
# Get the logs
systemctl --user status spotifyd.service
```
