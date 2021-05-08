local remap = vim.api.nvim_set_keymap

local function _setup(cfg)
    for key, val in pairs(cfg) do
        vim.g['vimwiki_' .. key] = val
    end
end

function wiki(path, opts)
    cfg = {
        path                = path,
        syntax              = 'markdown',
        index               = 'index',
        diary_rel_path      = '',
        diary_index         = 'diary',
        ext                 = '.md',
        links_space_char    = '-',
        auto_tags           = 1,
        auto_diary_index    = 1,
        auto_diary_index    = 1,
        auto_generate_links = 1,
        nested_syntaxes     = {
            starlark = "python",
        },
    }

    for key, value in pairs(opts or {}) do
        cfg[key] = value
    end

    return cfg
end

function setup(cfg)
    -- defaults
    _setup({
        markdown_link_ext = 1,
        url_maxsave = 0,
        global_ext = 0,
        folding = '',
        key_mappings = {
            table_mappings = 0,
        },
    })

    -- add extra
    _setup(cfg)
    remap("n", "<Leader>wo", "<cmd>!open http://localhost:8080/%:t:r.html<CR>", { noremap = true })

    vim.cmd [[autocmd FileType vimwiki setlocal spell]]
end

return {
    setup = setup,
    wiki = wiki,
}
