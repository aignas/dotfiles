function setup(config)
    for key, val in pairs(config) do
        vim.g['eskk#' .. key ] = val
    end

    vim.cmd [[lang en_US.UTF-8]]
end

vim.g.skk_path = vim.env.XDG_DATA_HOME .. '/nvim/skk'
vim.cmd [[
if finddir('/usr/share/skk')
    let g:skk_path = '/usr/share/skk'
endif
]]

setup({
    dictionary =       { path = vim.g.skk_path .. '/skk-jisyo.s' },
    large_dictionary = { path = vim.g.skk_path .. '/SKK-JISYO.L' },
})

return {
    setup = setup,
}
