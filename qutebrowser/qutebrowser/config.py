config.load_autoconfig(False)

c.url.start_pages = ["https://www.archlinux.org/"]
config.bind('<Ctrl+/>', 'hint links spawn --detach mpv {hint-url}')
