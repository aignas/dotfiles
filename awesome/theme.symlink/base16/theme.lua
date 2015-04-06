-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

local theme_dir = os.getenv("HOME") .. "/.config/awesome/theme/base16/"

-- {{{ Main
theme = {}
theme.wallpaper = theme_dir .. "base16-background.png"
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- The color scheme for base 16
theme.colorscheme = {}
theme.colorscheme[1] = "#151515"   -- Black 
theme.colorscheme[2] = "#202020"
theme.colorscheme[3] = "#303030"
theme.colorscheme[4] = "#505050"   -- Grey
theme.colorscheme[5] = "#b0b0b0"
theme.colorscheme[6] = "#d0d0d0"
theme.colorscheme[7] = "#e0e0e0"
theme.colorscheme[8] = "#f5f5f5"   -- White
theme.colorscheme[9] = "#ac4142"   -- Red
theme.colorscheme[10] = "#d28445"   -- Orange
theme.colorscheme[11] = "#f4bf75"   -- Yellow
theme.colorscheme[12] = "#90a959"   -- Green
theme.colorscheme[13] = "#75b5aa"   -- Light Blue
theme.colorscheme[14] = "#6a9fb5"   -- Blue
theme.colorscheme[15] = "#aa759f"   -- Purple
theme.colorscheme[16] = "#8f5536"   -- Brown

-- {{{ Colors
theme.fg_normal  = theme.colorscheme[7]
theme.bg_normal  = theme.colorscheme[1]
theme.fg_focus   = theme.colorscheme[8]
theme.bg_focus   = theme.colorscheme[2]
theme.fg_urgent  = theme.colorscheme[9]
theme.bg_urgent  = theme.colorscheme[3]
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 1
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.colorscheme[12]
theme.border_marked = theme.fg_urgent
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.border_focus
theme.titlebar_bg_normal = theme.border_normal
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
theme.taglist_bg_focus = theme.colorscheme[4]
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.bg_urgent
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
theme.menu_height = 15
theme.menu_width  = 100
theme.menu_border_color = theme.border_normal
theme.menu_bg_normal = theme.bg_normal
theme.menu_fg_normal = theme.bf_normal
theme.menu_bg_focus = theme.bg_focus
theme.menu_fg_focus = theme.fg_focus
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme_dir .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = theme_dir .. "/taglist/squarez.png"
theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme_dir .. "/awesome-icon.svg"
theme.menu_submenu_icon      = theme_dir .. "/submenu.svg"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme_dir .. "/layouts/tile.svg"
theme.layout_tileleft   = theme_dir .. "/layouts/tileleft.svg"
theme.layout_tilebottom = theme_dir .. "/layouts/tilebottom.svg"
theme.layout_tiletop    = theme_dir .. "/layouts/tiletop.svg"
theme.layout_fairv      = theme_dir .. "/layouts/fairv.png"
theme.layout_fairh      = theme_dir .. "/layouts/fairh.png"
theme.layout_spiral     = theme_dir .. "/layouts/spiral.svg"
theme.layout_dwindle    = theme_dir .. "/layouts/dwindle.svg"
theme.layout_max        = theme_dir .. "/layouts/max.svg"
theme.layout_fullscreen = theme_dir .. "/layouts/fullscreen.svg"
theme.layout_magnifier  = theme_dir .. "/layouts/magnifier.svg"
theme.layout_floating   = theme_dir .. "/layouts/floating.svg"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme_dir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme_dir .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme_dir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme_dir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme_dir .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme_dir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme_dir .. "/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
