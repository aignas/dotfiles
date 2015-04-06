-- powee battery widget
-- Written by Ignas Anikevicius (gns_ank)
--
--{{{ Environment

local setmetatable = setmetatable
local tostring = tostring
local tonumber = tonumber
local string = string
local math = math

local io = require('io')
local os = require('os')

local theme = require('beautiful').get()
local naughty = require('naughty')
local awful = require('awful')
local wibox = require('wibox')

local capi = {
    awesome = awesome,
    timer = timer
}
--}}}

powee = { mt = {} }

--{{{ Config
-- Make an empty table for the powee commands
powee.cfg = setmetatable({}, { __mode = 'k' })

-- Some aliases to ease my life
powee.cfg = {
    timeout = 1,
    critical = 10,
    smapi = true,
    symbols = {
        charging = '▲',
        discharging = '▼',
        idle = '◆',
        unknown = '◆',
    },
    animation = {
        timeout = 0.5
    }
}

local current = {
    state = '',
    percent = '',
    warning = nil,
    animation = {
        frame = 0,
        lock = false
    },
}


--}}}

--{{{ Some common functions
local function sleep (n)
    os.execute("sleep " .. tonumber(n))
end

-- This is a helper function, which just reads the files
local function powee_read (bat, file)
    local bat = tostring(bat) or 0
    local file = file or 'remaining_percent'
    local dir = 'BAT' .. bat ..'/'

    -- Read different directories if we use smapi
    if powee.cfg.smapi then
        dir = '/sys/devices/platform/smapi/' .. dir
    else
        dir = '/sys/class/power_supply/' .. dir
    end

    -- Default value if an error happens
    local f = io.open(dir .. file, 'r') or false

    -- error if the file does not exist
    if not f then return f end

    -- Return the value if the file exists
    r = f:read()
    f:close()
    return r
end

---
-- function to define a colormap depending on the given value
-- {val, min, max} these are the appropriate values
---
local function color(args)
    val = tonumber(args.val)
    min = tonumber(args.min)
    max = tonumber(args.max)

    c_start  = args.color or { 233,66,66 }
    c_finish = args.to_color or { 77,233,66 }
    f = val/(max - min) - .5

    r_diff = c_finish[1] - c_start[1]
    g_diff = c_finish[2] - c_start[2]
    b_diff = c_finish[3] - c_start[3]

    -- calculate rgb values
    r_v = c_start[1] + r_diff * (math.sin(f*math.pi)+1)/2
    g_v = c_start[2] + g_diff * (math.sin(f*math.pi)+1)/2
    b_v = c_start[3] + b_diff * (math.sin(f*math.pi)+1)/2

    -- do some string magic
    return string.format("#%02x%02x%02x", r_v, g_v, b_v)
end

--}}}

--{{{ Widget
--[

local warning = {}

---
-- This is a local function which just prints of a warning if the battery level
-- is too low
---
function warning.low_batt ( percent )
    local percent = ('(' .. percent .. '%)') or ''
    local text = 'Please <b>plug in</b> into a power socket or it will turn off soon.'

    current.warning = naughty.notify({
        title = 'Battery level is critical' .. percent,
        text = awful.util.linewrap(text, 40),
        preset = naughty.config.presets.critical
    })
end

---
-- This is a function for getting the summary on the details of the battery
---
function powee.get_info (bat)
    local bat = bat or 0
    local percent = powee_read(bat, 'remaining_percent')
    local current = powee_read(bat, 'current_avg')/1000 .. 'A /' ..
                    powee_read(bat, 'current_now')/1000 .. 'A'
    local current = powee_read(bat, 'current_avg')/1000 .. 'A /' ..
                    powee_read(bat, 'current_now')/1000 .. 'A'
end

---
-- This is an update function for the widget which updates the widget itself and
-- then it issues a warning in case the battery level is too low.
---
local update = function (mybat, myperc, mytext)
    local r = 0
    local state = "unknown"

    if powee.cfg.smapi then
        r = powee_read(0, 'remaining_percent')
        state = powee_read(0, 'state')
    else
        local now = powee_read(0, 'energy_now')
        local full = powee_read(0, 'energy_full')
        r = tonumber(now)/tonumber(full)
        state = powee_read(0, 'status')
    end
    
    -- Check if we read the values at all
    if not r or not state then return false end
    -- lowercase state label
    state = state:lower()

    -- Check if the battery is low
    if tonumber(r) < powee.cfg.critical then
        if current.warning then naughty.destroy(current.warning) end
        if state ~= 'charging' then
            warning.low_batt(r)
        end
    end

    -- Update only if something has changed
    if r ~= current.percent then
        myperc:set_text(r)
        mybat:set_value(r) 
        mybat:set_color(color({min=0,max=100,val=r}))

        current.percent = r
    end

    if state ~= current.state then
        -- translate state string into symbols above
        local str = powee.cfg.symbols[state] or powee.cfg.symbols['unknown']

        mytext:set_text(str) 
        mybat:set_value(r) 

        current.state = state
        current.animation.frame = 0
    end

    return true
end

local charging_animate = function (mybat)
    -- Update only if something has changed
    if current.state == "charging" and not current.animation.lock then
        current.animation.lock = true
        local i = current.animation.frame
        local setv = current.percent

        if i ~= 0 then
            -- We animate 50 - 60 - 80 - 100
            local j = math.floor(setv/20)
            setv = (j+i)*20
            
            current.animation.frame = (i + 1) % (6-j)
        else
            current.animation.frame = i + 1
        end

        mybat:set_value(setv) 
        current.animation.lock = false
    end

    return not current.animation.lock
end

powee.new = function (cfg)
    -- The config will be either the passed or the default one.
    local cfg = cfg or powee.cfg

    -- Initialize the battery itself
    mybat = awful.widget.progressbar({
        width = 6,
        height = 14
    })
    mybat:set_background_color('#000000')
    mybat:set_vertical(true)
    mybat:set_max_value(100)
    mybat:set_ticks(true)
    mybat:set_ticks_gap(1)
    mybat:set_ticks_size(2)

    myperc = wibox.widget.textbox()
    myperc:set_text('%%')

    mytext = wibox.widget.textbox()
    mytext:set_text('◆')
        

    local w = wibox.layout.fixed.horizontal()
    w:add(wibox.layout.margin(mybat, 2, 2, 2, 2)) -- w, l, r, t, b
    w:add(wibox.layout.margin(myperc, 1, 3, 3, 2)) -- w, l, r, t, b
    w:add(wibox.layout.margin(mytext, 1, 3, 2, 2)) -- w, l, r, t, b

    -- update the widget
    update (mybat, myperc, mytext)

    -- Register all of the timers with the functions
    local timer = capi.timer { timeout = cfg.timeout }
    timer:connect_signal("timeout", function() update(mybat, myperc, mytext) end)
    timer:start()
    timer:emit_signal("timeout")

    local charging_timer = capi.timer { timeout = cfg.animation.timeout }
    charging_timer:connect_signal("timeout", function () charging_animate(mybat) end)
    charging_timer:start()
    charging_timer:emit_signal("timeout")

    -- We want a tooltip, which would give us some information on the current
    -- battery parameters
    powee_t = awful.tooltip({
        objects = { w },
        timer_function = function()
            if powee.cfg.smapi then
                local prc = powee_read(0, 'remaining_percent') .. "%"
                local pow = powee_read(0, 'power_avg') / 1000 .. "W"
                local pow_now = powee_read(0, 'power_now') / 1000 .. "W"
                local cur = powee_read(0, 'current_avg') / 1000 .. "A"
                local cur_now = powee_read(0, 'current_now') / 1000 .. "A"
                local vol = powee_read(0, 'voltage') / 1000 .. "V"

                return "Current charge: " .. prc .. "\n"
                    .. "    Power draw: " .. pow .. " (" .. pow_now .. ")" .. "\n"
                    .. "  Current draw: " .. cur .. " (" .. cur_now .. ")" .. "\n"
                    .. "       Voltage: " .. vol
            else
                local now = powee_read(0, 'energy')
                local full = powee_read(0, 'energy_full')
                local prc = tonumber(now)/tonumber(full) .. "%"
                local pow = powee_read(0, 'power_now') / 1000
                local vol = powee_read(0, 'voltage_now') / 1000
                local cur = pow/vol .. "A"
                vol = vol .. "V"

                return "Current charge: " .. prc .. "\n"
                    .. "    Power draw: " .. pow .. " (" .. pow_now .. ")" .. "\n"
                    .. "  Current draw: " .. cur .. " (" .. cur_now .. ")" .. "\n"
                    .. "       Voltage: " .. vol
            end
        end,
    })

    -- return the widget
    return w
end

--]]
--}}}


-- Set the metatable, like other awful widgets and return it
function powee.mt:__call(...)
    return powee.new(...)
end

return setmetatable(powee, powee.mt)

-- ft - filetype
-- et - expandtab
-- sw - shiftwidth
-- ts - tabstop
-- sts - shifttabstop
-- tw - textwidth
-- fdm - foldmethod
-- vim: ft=lua:et:sw=4:ts=8:sts=4:tw=80:fdm=marker
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker
