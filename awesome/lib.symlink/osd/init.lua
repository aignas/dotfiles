----------------------------------------------------------------------------
-- @author koniu &lt;gkusnierz@gmail.com&gt;
-- @copyright 2008 koniu
-- @release v3.5
----------------------------------------------------------------------------

-- Package environment
local pairs = pairs
local table = table
local type = type
local string = string
local pcall = pcall
local capi = { screen = screen,
               awesome = awesome,
               dbus = dbus,
               timer = timer,
               awesome = awesome }
local button = require("awful.button")
local util = require("awful.util")
local bt = require("beautiful")
local wibox = require("wibox")
local surface = require("gears.surface")
local cairo = require("lgi").cairo

--- Notification library
local osd = {}

--- osd configuration - a table containing common popup settings.
osd.config = {}
--- Space between popups and edge of the workarea. Default: 4
osd.config.padding = 4
--- Spacing between popups. Default: 1
osd.config.spacing = 1
--- List of directories that will be checked by getIcon()
--   Default: { "/usr/share/pixmaps/", }
osd.config.icon_dirs = { "/usr/share/pixmaps/", }
--- List of formats that will be checked by getIcon()
--   Default: { "png", "gif" }
osd.config.icon_formats = { "png", "gif" }
--- Callback used to modify or reject notifications.
--   Default: nil
--   Example:
--      osd.config.notify_callback = function(args)
--          args.text = 'prefix: ' .. args.text
--          return args
--      end
osd.config.notify_callback = nil


--- Notification Presets - a table containing presets for different purposes
-- Preset is a table of any parameters available to notify(), overriding default
-- values (@see defaults)
-- You have to pass a reference of a preset in your notify() call to use the preset
-- The presets "low", "normal" and "critical" are used for notifications over DBUS
-- @field low The preset for notifications with low urgency level
-- @field normal The default preset for every notification without a preset that will also be used for normal urgency level
-- @field critical The preset for notifications with a critical urgency level
-- @class table
osd.config.presets = {
    normal = {},
    low = {
        timeout = 5
    },
    critical = {
        bg = "#ff0000",
        fg = "#ffffff",
        timeout = 0,
    }
}

--- Default values for the params to notify().
-- These can optionally be overridden by specifying a preset
-- @see osd.config.presets
-- @see osd.notify
osd.config.defaults = {
    timeout = 5,
    text = "",
    screen = 1,
    ontop = true,
    margin = "5",
    border_width = "1",
    position = "top_right"
}

-- DBUS Notification constants
local urgency = {
    low = "\0",
    normal = "\1",
    critical = "\2"
}

--- DBUS notification to preset mapping
-- The first element is an object containing the filter
-- If the rules in the filter matches the associated preset will be applied
-- The rules object can contain: urgency, category, appname
-- The second element is the preset

osd.config.mapping = {
    {{urgency = urgency.low}, osd.config.presets.low},
    {{urgency = urgency.normal}, osd.config.presets.normal},
    {{urgency = urgency.critical}, osd.config.presets.critical}
}

-- Counter for the notifications
-- Required for later access via DBUS
local counter = 1

-- True if notifying is suspended
local suspended = false

--- Index of notifications per screen and position. See config table for valid
-- 'position' values. Each element is a table consisting of:
-- @field box Wibox object containing the popup
-- @field height Popup height
-- @field width Popup width
-- @field die Function to be executed on timeout
-- @field id Unique notification id based on a counter
osd.notifications = { suspended = { } }
for s = 1, capi.screen.count() do
    osd.notifications[s] = {
        top_left = {},
        top_right = {},
        bottom_left = {},
        bottom_right = {},
    }
end

--- Suspend notifications
function osd.suspend()
    suspended = true
end

--- Resume notifications
function osd.resume()
    suspended = false
    for i, v in pairs(osd.notifications.suspended) do
        v.box.visible = true
        if v.timer then v.timer:start() end
    end
    osd.notifications.suspended = { }
end

--- Toggle notification state
function osd.toggle()
    if suspended then
        osd.resume()
    else
        osd.suspend()
    end
end

-- Evaluate desired position of the notification by index - internal
-- @param idx Index of the notification
-- @param position top_right | top_left | bottom_right | bottom_left
-- @param height Popup height
-- @param width Popup width (optional)
-- @return Absolute position and index in { x = X, y = Y, idx = I } table
local function get_offset(screen, position, idx, width, height)
    local ws = capi.screen[screen].workarea
    local v = {}
    local idx = idx or #osd.notifications[screen][position] + 1
    local width = width or osd.notifications[screen][position][idx].width

    -- calculate x
    if position:match("left") then
        v.x = ws.x + osd.config.padding
    else
        v.x = ws.x + ws.width - (width + osd.config.padding)
    end

    -- calculate existing popups' height
    local existing = 0
    for i = 1, idx-1, 1 do
        existing = existing + osd.notifications[screen][position][i].height + naughty.config.spacing
    end

    -- calculate y
    if position:match("top") then
        v.y = ws.y + osd.config.padding + existing
    else
        v.y = ws.y + ws.height - (osd.config.padding + height + existing)
    end

    -- if positioned outside workarea, destroy oldest popup and recalculate
    if v.y + height > ws.y + ws.height or v.y < ws.y then
        idx = idx - 1
        osd.destroy(naughty.notifications[screen][position][1])
        v = get_offset(screen, position, idx, width, height)
    end
    if not v.idx then v.idx = idx end

    return v
end

-- Re-arrange notifications according to their position and index - internal
-- @return None
local function arrange(screen)
    for p,pos in pairs(osd.notifications[screen]) do
        for i,notification in pairs(osd.notifications[screen][p]) do
            local offset = get_offset(screen, p, i, notification.width, notification.height)
            notification.box:geometry({ x = offset.x, y = offset.y })
            notification.idx = offset.idx
        end
    end
end

--- Destroy notification by notification object
-- @param notification Notification object to be destroyed
-- @return True if the popup was successfully destroyed, nil otherwise
function osd.destroy(notification)
    if notification and notification.box.visible then
        if suspended then
            for k, v in pairs(osd.notifications.suspended) do
                if v.box == notification.box then
                    table.remove(osd.notifications.suspended, k)
                    break
                end
            end
        end
        local scr = notification.screen
        table.remove(osd.notifications[scr][notification.position], notification.idx)
        if notification.timer then
            notification.timer:stop()
        end
        notification.box.visible = false
        arrange(scr)
        return true
    end
end

-- Get notification by ID
-- @param id ID of the notification
-- @return notification object if it was found, nil otherwise
local function getById(id)
    -- iterate the notifications to get the notfications with the correct ID
    for s = 1, capi.screen.count() do
        for p,pos in pairs(osd.notifications[s]) do
            for i,notification in pairs(osd.notifications[s][p]) do
                if notification.id == id then
                    return notification
                 end
            end
        end
    end
end

--- Create notification. args is a dictionary of (optional) arguments.
-- @param text Text of the notification. Default: ''
-- @param title Title of the notification. Default: nil
-- @param timeout Time in seconds after which popup expires.
--   Set 0 for no timeout. Default: 5
-- @param hover_timeout Delay in seconds after which hovered popup disappears.
--   Default: nil
-- @param screen Target screen for the notification. Default: 1
-- @param position Corner of the workarea displaying the popups.
--   Values: "top_right" (default), "top_left", "bottom_left", "bottom_right".
-- @param ontop Boolean forcing popups to display on top. Default: true
-- @param height Popup height. Default: nil (auto)
-- @param width Popup width. Default: nil (auto)
-- @param font Notification font. Default: beautiful.font or awesome.font
-- @param icon Path to icon. Default: nil
-- @param icon_size Desired icon size in px. Default: nil
-- @param fg Foreground color. Default: beautiful.fg_focus or '#ffffff'
-- @param bg Background color. Default: beautiful.bg_focus or '#535d6c'
-- @param border_width Border width. Default: 1
-- @param border_color Border color.
--   Default: beautiful.border_focus or '#535d6c'
-- @param run Function to run on left click. Default: nil
-- @param preset Table with any of the above parameters. Note: Any parameters
--   specified directly in args will override ones defined in the preset.
-- @param replaces_id Replace the notification with the given ID
-- @param callback function that will be called with all arguments
--  the notification will only be displayed if the function returns true
--  note: this function is only relevant to notifications sent via dbus
-- @usage osd.notify({ title = "Achtung!", text = "You're idling", timeout = 0 })
-- @return The notification object
function osd.notify(args)
    if osd.config.notify_callback then
        args = osd.config.notify_callback(args)
        if not args then return end
    end

    -- gather variables together
    local preset = util.table.join(osd.config.defaults or {},
        args.preset or osd.config.presets.normal or {})
    local timeout = args.timeout or preset.timeout
    local icon = args.icon or preset.icon
    local icon_size = args.icon_size or preset.icon_size
    local text = args.text or preset.text
    local title = args.title or preset.title
    local screen = args.screen or preset.screen
    local ontop = args.ontop or preset.ontop
    local width = args.width or preset.width
    local height = args.height or preset.height
    local hover_timeout = args.hover_timeout or preset.hover_timeout
    local opacity = args.opacity or preset.opacity
    local margin = args.margin or preset.margin
    local border_width = args.border_width or preset.border_width
    local position = args.position or preset.position

    -- beautiful
    local beautiful = bt.get()
    local font = args.font or preset.font or beautiful.font or capi.awesome.font
    local fg = args.fg or preset.fg or beautiful.fg_normal or '#ffffff'
    local bg = args.bg or preset.bg or beautiful.bg_normal or '#535d6c'
    local border_color = args.border_color or preset.border_color or beautiful.bg_focus or '#535d6c'
    local notification = { screen = screen }

    -- replace notification if needed
    if args.replaces_id then
        local obj = getById(args.replaces_id)
        if obj then 
            notification = obj
        end
        -- ... may use its ID
        if args.replaces_id > counter then
            counter = counter + 1
            notification.id = counter
        end
        -- Change the timeout!!!
    else
        -- get a brand new ID
        counter = counter + 1
        notification.id = counter
    end

    notification.position = position

    if title then title = title .. "\n" else title = "" end

    -- hook destroy
    local die = function () osd.destroy(notification) end
    if timeout > 0 then
        local timer_die = capi.timer { timeout = timeout }
        timer_die:connect_signal("timeout", die)
        if not suspended then
            timer_die:start()
        end
        notification.timer = timer_die
    end
    notification.die = die

    local run = function ()
        if args.run then
            args.run(notification)
        else
            die()
        end
    end

    local hover_destroy = function ()
        if hover_timeout == 0 then
            die()
        else
            if notification.timer then notification.timer:stop() end
            notification.timer = capi.timer { timeout = hover_timeout }
            notification.timer:connect_signal("timeout", die)
            notification.timer:start()
        end
    end

    -- create textbox
    local textbox = wibox.widget.textbox()
    local marginbox = wibox.layout.margin()
    marginbox:set_margins(margin)
    marginbox:set_widget(textbox)
    textbox:set_valign("middle")
    textbox:set_font(font)

    local function setMarkup(pattern, replacements)
        textbox:set_markup(string.format('<b>%s</b>%s', title:gsub(pattern, replacements), text:gsub(pattern, replacements)))
    end
    local function setText()
        textbox:set_text(string.format('%s %s', title, text))
    end

    -- First try to set the text while only interpreting <br>.
    -- (Setting a textbox' .text to an invalid pattern throws a lua error)
    if not pcall(setMarkup, "<br.->", "\n") then
        -- That failed, escape everything which might cause an error from pango
        if not pcall(setMarkup, "[<>&]", { ['<'] = "&lt;", ['>'] = "&gt;", ['&'] = "&amp;" }) then
            -- Ok, just ignore all pango markup. If this fails, we got some invalid utf8
            if not pcall(setText) then
                textbox:set_markup("<i>&lt;Invalid markup or UTF8, cannot display message&gt;</i>")
            end
        end
    end

    -- create iconbox
    local iconbox = nil
    local iconmargin = nil
    local icon_w, icon_h = 0, 0
    if icon then
        -- try to guess icon if the provided one is non-existent/readable
        if type(icon) == "string" and not util.file_readable(icon) then
            icon = util.geticonpath(icon, osd.config.icon_formats, naughty.config.icon_dirs, icon_size)
        end

        -- if we have an icon, use it
        if icon then
            iconbox = wibox.widget.imagebox()
            iconmargin = wibox.layout.margin(iconbox, margin, margin, margin, margin)
            local img = surface.load(icon)
            if icon_size then
                local scaled = cairo.ImageSurface(cairo.Format.ARGB32, icon_size, icon_size)
                local cr = cairo.Context(scaled)
                cr:scale(icon_size / img:get_height(), icon_size / img:get_width())
                cr:set_source_surface(img, 0, 0)
                cr:paint()
                img = scaled
            end
            iconbox:set_resize(false)
            iconbox:set_image(img)
            icon_w = img:get_width()
            icon_h = img:get_height()
        end
    end

    -- create container wibox
    notification.box = wibox({ fg = fg,
                               bg = bg,
                               border_color = border_color,
                               border_width = border_width,
                               type = "notification" })

    if hover_timeout then notification.box:connect_signal("mouse::enter", hover_destroy) end

    -- calculate the height
    if not height then
        local w, h = textbox:fit(-1, -1)
        if iconbox and icon_h + 2 * margin > h + 2 * margin then
            height = icon_h + 2 * margin
        else
            height = h + 2 * margin
        end
    end

    -- calculate the width
    if not width then
        local w, h = textbox:fit(-1, -1)
        width = w + (iconbox and icon_w + 2 * margin or 0) + 2 * margin
    end

    -- crop to workarea size if too big
    local workarea = capi.screen[screen].workarea
    if width > workarea.width - 2 * (border_width or 0) - 2 * (osd.config.padding or 0) then
        width = workarea.width - 2 * (border_width or 0) - 2 * (osd.config.padding or 0)
    end
    if height > workarea.height - 2 * (border_width or 0) - 2 * (osd.config.padding or 0) then
        height = workarea.height - 2 * (border_width or 0) - 2 * (osd.config.padding or 0)
    end

    -- set size in notification object
    notification.height = height + 2 * (border_width or 0)
    notification.width = width + 2 * (border_width or 0)

    -- position the wibox
    local offset = get_offset(screen, notification.position, nil, notification.width, notification.height)
    notification.box.ontop = ontop
    notification.box:geometry({ width = width,
                                height = height,
                                x = offset.x,
                                y = offset.y })
    notification.box.opacity = opacity
    notification.box.visible = true
    notification.idx = offset.idx

    -- populate widgets
    local layout = wibox.layout.fixed.horizontal()
    if iconmargin then
        layout:add(iconmargin)
    end
    layout:add(marginbox)
    notification.box:set_widget(layout)

    -- Setup the mouse events
    layout:buttons(util.table.join(button({ }, 1, run), button({ }, 3, die)))

    -- insert the notification to the table
    table.insert(osd.notifications[screen][notification.position], notification)

    if suspended then
        notification.box.visible = false
        table.insert(osd.notifications.suspended, notification)
    end

    -- return the notification
    return notification
end

return osd

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
