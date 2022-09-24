# Setup instructions for SpotifyD

```
secret-tool store --label='daemons' application rust-keyring service spotifyd username <username>
systemctl --user start spotifyd.service
systemctl --user enable spotifyd.service
```
