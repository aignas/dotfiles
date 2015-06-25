-- A Keyboard widget
--      ideas borrowed from the awesome wiki.
--
--{{{ Environment

local setmetatable = setmetatable
local tostring = tostring
local tonumber = tonumber

local awful = require('awful')
local theme = require('beautiful').get()
local naughty = require('naughty')
local imagebox = require('wibox.widget.imagebox')
local textbox = require('wibox.widget.textbox')

local capi = {
    client = client,
    mouse = mouse
}

--}}}

kbdee = { mt = {} }
kbdee.layout = {}
kbdee.variant = {}

--{{{ Configuration of the widget
-- Make an empty table for the setxkbmap commands
kbdee.cfg = setmetatable({}, { __mode = 'k' })

-- Some aliases to ease my life
kbdee.cfg = {
    img_dir = nil,
    icon_ext = nil,
    layout = {
        { "gb" },
    },
    setxkbmap = {
        model = ""
    },
    xmodmap = nil
}

local cache = {
    current = 0,
    variant = 1
}


--}}}

--[[
Design of the whole thing:

    I have a widget box which is updated via signals.

    I have a snippet which stores and updates layouts per window.

    I can configure the thing.
--]]

--{{{ Utils
-- A function stolen from
--    http://lua-users.org/wiki/SplitJoin
local Split = function (str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gmatch(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end
--}}}

--{{{ Layout commands
--
--- This wraps the setxkbmap command, so that it becomes easier to use it
-- Arguments are defined by a table list
kbdee.layout.setxkbmap = function (args)
    -- Assign local vars
    local layout = tostring(args.layout)
    local variant = tostring(args.variant) or ""
    local xmodmap = tostring(args.xmodmap) or nil

    -- Check if a layout is specified
    if #layout == 0 then
        naughty.notify({ 
            preset = naughty.config.presets.critical,
            title = "KBDee",
            text = "You tried to set the layout without actually specifying it!"
        })
    end

    -- Set the layout cmd
    local cmdstr = "setxkbmap" ..
                    " -layout " .. layout

    -- Check if variant entry is valid:
    if #variant ~= 0 then 
        cmdstr = cmdstr .. " -variant " .. variant
    end

    -- Add the xmodmap if present
    if xmodmap then
        cmdstr = cmdstr .. " && xmodmap " .. xmodmap
    end

    return awful.util.spawn_with_shell(cmdstr)
end

--- Switches a layout and interacts with userdata which is configured before
-- initializing the commands (hopefully)...
kbdee.layout.switch = function (idx, var, force)
    --Assign local vars
    local layout_table = kbdee.cfg.layout
    local idx = tonumber(idx)
    local var = tonumber(var) or 1
    local success = false
    local force = force or false

    -- Execute setxkbmap
    if force or idx ~= cache.current or var ~= cache.variant then
        local t = {}

        if type(layout_table[idx][var]) == "table" then
            t = layout_table[idx][var]
        else
            t = Split(layout_table[idx][var], "_")
        end

        if #t == 1 then
            t[2] = ""
        end

        success = kbdee.layout.setxkbmap({
                    layout = t[1], variant = t[2],
                    xmodmap = kbdee.cfg.xmodmap
                })
    end

    if success then
        cache.current = idx
        cache.variant = var

        w:emit_signal("kbdee::update")
        local cl = awful.client.focus.history.get(capi.mouse.screen, 0)
        if cl then cl:emit_signal("kbdee::update") end
    end

    return success
end

kbdee.variant.rotate = function(idx)
    local idx = idx or cache.current
    local len = #(kbdee.cfg.layout[cache.current])

    if len > 1 then
        a = kbdee.cfg.layout[idx]
        table.insert(a, len + 1, a[1])
        table.remove(a, 1)
        kbdee.cfg.layout[idx] = a
    else
        return true
    end

    if idx == cache.current then
        -- Switch to the new layout if we have rotated the current layout
        kbdee.layout.switch(cache.current, cache.variant, true)
    end

    local t = Split(kbdee.cfg.layout[idx][1], "_")
    if not t[2] then
        t[2] = "default"
    end

    icon_path = nil
    if kbdee.cfg.img_dir ~= nil then
        icon_path = kbdee.cfg.img_dir .. t[1] .. kbdee.cfg.icon_ext
    end

    naughty.notify({
        title="KBDee",
        text="Default layout for slot " .. idx .. " is\n"
             .. t[1] .. "(" .. t[2] .. ")",
        icon=icon_path
    })
end

--- Selects the next layout in the list
kbdee.layout.next = function ()
    local idx = cache.current + 1

    -- Out of bounds ?
    if idx > kbdee.cfg.layout_table then
        idx = 1
    end

    return kbdee.layout.switch({
        idx = idx
    })
end

--- Selects the previous layout in the list
kbdee.layout.prev = function ()
    local idx = cache.current - 1

    -- Out of bounds ?
    if idx == 0 then
        idx = #kbdee.cfg.layout_table
    end

    return kbdee.layout.switch({
        idx = idx
    })
end

function kbdee.layout.menu_gen ()
    local menu_table = {}

    for i,entry in ipairs(kbdee.cfg.layout) do
        for j, layout in ipairs(entry) do
            local t = Split(layout, "_")
            if not t[2] then
                t[2] = ""
            end
            menu_table[#menu_table + 1] = { 
                -- Name of the layout
                t[1] .. " " .. t[2],
                function () kbdee.layout.switch(i,j) end
            }
        end
    end

    return awful.menu({items = menu_table})
end
--}}}

--{{{ Widget commands
local update = function (w)
    local layout = kbdee.cfg.layout[cache.current][cache.variant]

    if type(layout) ~= "table" then
        layout = Split(layout, "_")
    end

    if kbdee.cfg.img_dir ~= nil then
        w:set_image(kbdee.cfg.img_dir .. "/48/" .. layout[1] .. ".png")
    else
        w:set_text(layout[1])
    end
end

kbdee.new = function ()
    if kbdee.cfg.img_dir ~= nil then
        w = imagebox()
    else
        w = textbox()
    end

    -- Update the widget
    update(w)

    -- create some signals
    capi.client.add_signal("kbdee::update")
    capi.client.add_signal("property::kbdee::layout")
    capi.client.add_signal("property::kbdee::variant")
    w:add_signal("kbdee::update")

    -- Connect them
    w:connect_signal("kbdee::update", function () update (w) end)

    capi.client.connect_signal("focus",
        function (c)
            local idx = awful.client.property.get(c,"kbdee::layout") or 1
            local var = awful.client.property.get(c,"kbdee::variant") or 1

            -- Do the actual switching
            kbdee.layout.switch(idx, var)
        end
    )

    capi.client.connect_signal("kbdee::update", 
        function (c) 
            awful.client.property.set(c, "kbdee::layout", cache.current) 
            awful.client.property.set(c, "kbdee::variant", cache.variant) 
        end)
    
    -- return the widget
    return w
end
--}}}


kbdee.init = function()
    -- Set the caches properly
    local a = kbdee.cfg.defaults or {1,1}
    cache.current = a[1]
    cache.variant = a[2]

    -- Initialise the menu and the widget
    local menu = kbdee.layout.menu_gen()
    local wi = kbdee.new()

    -- Set the default layout (force the switch)
    kbdee.layout.switch(a[1], a[2], true)

    return wi, menu
end

-- Set the metatable, like other awful widgets and return it
function kbdee.mt:__call(...)
    return kbdee.new(...)
end

return setmetatable(kbdee, kbdee.mt)

-- ft - filetype
-- et - expandtab
-- sw - shiftwidth
-- ts - tabstop
-- sts - shifttabstop
-- tw - textwidth
-- fdm - foldmethod
-- vim: ft=lua:et:sw=4:ts=8:sts=4:tw=80:fdm=marker
