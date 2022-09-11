local wezterm = require 'wezterm'
return {
    color_scheme = 'Default Dark (base16)',
    font = wezterm.font 'Hack',

    unix_domains = {
        {
            name = 'unix',
        },
    },

    default_gui_startup_args = { 'connect', 'unix' },
}
