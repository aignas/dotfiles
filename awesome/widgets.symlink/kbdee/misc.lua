--{{{ Some leftover functions

function M.layout.xkb_check()
    local f = assert(io.popen("setxkbmap -query"))
    local l,v = "", ""
    local l_t, v_t = {},{}
    for line in f:lines() do
        if line:match("layout") then
            l = line:sub(13)
        end
        if line:match("variant") then
            v = line:sub(13)
        end
    end
    f:close()

    l_t = Split(l,",")
    l_v = Split(v,",")

    for i,k in ipairs(M.cfg.layout) do
        if k[1] == l_t[i] and k[2] == l_v[i] then
            M.cfg.current = i
            return true
        end
    end
    return false
end
--}}}
