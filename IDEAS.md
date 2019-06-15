# Making this better

A list of ideas, that could make this better:
- [ ] Rewrite the bootstrapping script in rust.  No need for:
  - [ ] My own logging framework.
  - [ ] Code can be unit tested.
  - [ ] However, it will be more expensive to maintain.
- [ ] Go back to the topical ordering, where I have functions to install
      packages. For example, it is strange that `dep` is being installed in
      `system` and not in `golang` install script.
- [ ] Make everything more lightweight.  Only the necessary should be
      installed.  Have an extra switch `--extras` to install the extras.  Extra
      packages sholud have:
      - [ ] `alacritty`
      - [ ] hack font
      - [ ] fira code font
- [ ] Use [whatchexec](https://github.com/watchexec/watchexec) instead of
      `fswatch`, because it is written in rust.
