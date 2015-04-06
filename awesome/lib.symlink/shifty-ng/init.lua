-- My take on shifty library (simplified and cleaned up); a serious rewrite
-- Author: gns-ank
--

-- {{{ Environment
local beautiful = require("beautiful")
local awful = require("awful")

-- core api to more streamline the whole code
local capi = {
  client = client,
  tag = tag,
  image = image,
  screen = screen,
  mouse = mouse,
  root = root,
  timer = timer
}


M = {}
-- }}}

--{{{ add : adds a tag
--@param args: table of optional arguments
--
function M.add(args)
  if not args then args = {} end
  local name = args.name or " "

  -- initialize a new tag object and its data structure
  local t = capi.tag{ name = name }

  -- tell set() that this is the first time
  awful.tag.setproperty(t, "initial", true)

  -- apply tag settings
  set(t, args)

  -- unless forbidden or if first tag on the screen, show the tag
  if not (awful.tag.getproperty(t,"nopopup") or args.noswitch) or #capi.screen[t.screen]:tags() == 1 then awful.tag.viewonly(t) end

  -- get the name or rename
  if args.name then
    t.name = args.name
  else
    -- FIXME: hack to delay rename for un-named tags for tackling taglist refresh
    --        which disabled prompt from being rendered until input
    awful.tag.setproperty(t, "initial", true)
    local f
    if args.position then
      f = function() rename(t, args.rename, true); tmr:stop() end
    else
      f = function() rename(t); tmr:stop() end
    end
    tmr = capi.timer({ timeout = 0.01 })
    tmr:connect_signal("timeout", f)
    tmr:start()
  end

  return t
end
--}}}

--{{{ rename
--@param tag: tag object to be renamed
--@param prefix: if any prefix is to be added
--@param no_selectall:
function M.rename(tag, prefix, no_selectall)
  local theme = beautiful.get()
  local t = tag or awful.tag.selected(capi.mouse.screen)
  local scr = t.screen
  local bg = nil
  local fg = nil
  local text = prefix or t.name
  local before = t.name

  if t == awful.tag.selected(scr) then 
    bg = theme.bg_focus or '#535d6c'
    fg = theme.fg_urgent or '#ffffff'
  else 
    bg = theme.bg_normal or '#222222'
    fg = theme.fg_urgent or '#ffffff'
  end

  awful.prompt.run( { 
    fg_cursor = fg, bg_cursor = bg, ul_cursor = "single",
    text = text, selectall = not no_selectall },
    taglist[scr][tag2index(t,scr)][1],
    function (name) if name:len() > 0 then t.name = name; end end, 
    completion,
    awful.util.getdir("cache") .. "/history_tags", nil,
    function ()
      if t.name == before then
        if awful.tag.getproperty(t, "initial") then del(t) end
      else
        awful.tag.setproperty(t, "initial", true)
        set(t)
      end
      tagkeys(capi.screen[scr])
      t:emit_signal("property::name")
    end
  )
end
--}}}
