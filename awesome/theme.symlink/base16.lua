-------------------------------
--    Base16 created
--    By Ignas A. (gns-ank)  --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

local home = os.getenv("HOME")

-- Load the default theme
theme = dofile(home .. '/.config/awesome/theme/base16/theme.lua')

theme.wallpaper_dir = { 
     home .. '/Wallpapers/nature_2011/',
     home .. '/Wallpapers/nature_2012/'
}
theme.wallpaper = {}

theme.font      = "Droid Sans Mono 8"
theme.icon_theme= "elementary"

theme.border_width  = 2

theme.logout_icon = '/usr/share/icons/' .. theme.icon_theme .. '/actions/system-log-out.png'

return theme
