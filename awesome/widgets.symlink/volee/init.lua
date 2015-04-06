-- volee volume widget
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

volee = { mt = {} }

-- Set the metatable, like other awful widgets and return it
function volee.mt:__call(...)
    return volee.new(...)
end

return setmetatable(volee, volee.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=indent
