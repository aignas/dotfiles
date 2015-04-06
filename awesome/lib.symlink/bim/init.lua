-- A mode utility to help with the key bindings
-- (C) Copyright Ignas Anikevicius
--
local ipairs = ipairs
local setmetatable = setmetatable
local table = table
local unpack = unpack
local string = require("string")

local capi = {
    keygrabber = keygrabber,
    client = client,
    screen = screen
}

local theme = require("beautiful").get()
local awful = {
    util = require("awful.util"),
    key = require("awful.key")
}
local naughty = require("naughty")

bim = { }

local data = {}
data.mode = {}
data.history = {}

-- Default keys
bim.exit_keys = {
    { {       }, "Escape",  function () end, stop_grab = true },
}


-- from awful.key
local ignore_modifiers = { "Lock", "Mod2" }

---
--Translate the modbindings
---
local trans_modifiers = function (mods)
    local mod = ''
    -- Construct the modifier key table
    for _,j in ipairs(mods) do
        -- Separate the modifiers
        if #mod ~= 0 then mod = mod .. '-' end
        -- Translate the mod bindings
        if      j == "Shift"    then mod = mod .. 'S'
        elseif  j == "Mod1"     then mod = mod .. 'A'
        elseif  j == "Mod4"     then mod = mod .. 'M'
        elseif  j == "Control"  then mod = mod .. 'C'
        end
    end

    return mod
end

local gen_description = function (keys)
    -- Generate information
    local description = ""
    local maxlk, maxlm = 0, 0
    for _, k in ipairs(keys) do
        if k.info then
            if maxlm < #k[1] then maxlm = #k[1] end
            if maxlk < #k[2] then maxlk = #k[2] end
        end
    end
    for _, k in ipairs(keys) do
        local mod = trans_modifiers (k[1])
        local key = k[2] .. ' '

        -- This alligns the definitions
        for i=#k[1], maxlm do mod = ' ' .. mod end
        for i=#k[2], maxlk do key = ' ' .. key end

        -- Construct the description string
        if k.info then
            description = description .. '\n' .. mod .. key .. ': ' .. k.info
        end
    end

    return description
end


bim.switchmode = function (keys, c)
    -- if the keys table is not given stop executing the command
    if not keys then return false end
    c = c or keys.client
    keys = awful.util.table.join(keys, bim.exit_keys)
    
    -- Insert the most recent entry to the history
    table.insert(data.history, 1, {keys, name, c})

    -- Generate description
    local name = keys.name or 'Unknown'
    name = name .. ":"
    local description = keys.info or ''

    -- Create a new notification
    for s=1, capi.screen.count() do
        if data.mode[s] then data.mode[s].die() end
        data.mode[s] = naughty.notify({
            title = name,
            text = description,
            screen = s,
            timeout = 0
        })
    end

    capi.keygrabber.run(function( pressedMod, pressedKey, event)
        -- if the event is a release event or a key is a modifier, continue
        if event == "release" 
            or pressedKey:match("_Lock") 
            or pressedKey:match("_R") 
            or pressedKey:match("_L") then
            return
        end

        -- The check is not case sensitive, which makes it nicer to distinguish
        -- between the Shift + l and l instead of Shift + L and l
        pressedKey = string.lower(pressedKey)

        -- delete the modifiers from ignore_modifiers table
        for i,k in ipairs(pressedMod) do
            if awful.util.table.hasitem(ignore_modifiers,k) then
                pressedMod[i] = nil
            end
        end

        -- Traverse the key table
        for _,k in ipairs(keys) do
            -- stop the keygrabber if no good keys were pressed
            if awful.key.match({ key = string.lower(k[2]), modifiers = k[1] }, pressedMod, pressedKey ) then

                if k.stop_grab or k.exit or type(k[3]) == "table" then
                    capi.keygrabber.stop()
                    for s=1, capi.screen.count() do
                        if data.mode[s] then data.mode[s].die() end
                    end
                end

                if type(k[3]) == "table" then
                    if #k[2] > 1 then k[2] = "<" .. k[2] .. ">" end
                    bim.switchmode(k[3], name .. (k.info or k[2]), c)
                else
                    if c then 
                        k[3](capi.client.focus)
                    else 
                        k[3]() 
                    end
                end

                -- Exit or come back
                if k.stop_grab or k.exit then 
                    if #data.history < 2 or k.exit then
                        -- clear the history, we are exiting the mode
                        data.history = {}
                    else
                        -- Delete the current and return to the previous
                        data.history[1] = nil
                        bim.switchmode(unpack(data.history[2]))
                    end
                end
            end
        end
    end)
end

return bim
