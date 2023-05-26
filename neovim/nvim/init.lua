if vim.env.XDG_CONFIG_HOME == nil then
    vim.env.XDG_CONFIG_HOME = vim.env.HOME .. '/.config'
end
if vim.env.XDG_DATA_HOME == nil then
    vim.env.XDG_DATA_HOME = vim.env.HOME .. '/.local/share'
end

vim.cmd.packadd "packer.nvim"
require('packer').startup({
    function()
        use {
            'wbthomason/packer.nvim',
            branch = 'master',
            opt = true,
        }

        use "williamboman/mason-lspconfig.nvim"
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/vim-vsnip'
        use 'hrsh7th/vim-vsnip-integ'
        use 'lervag/lists.vim'
        use 'lervag/vimtex'
        use 'lervag/wiki.vim'
        use 'mfussenegger/nvim-dap'
        -- use 'mfussenegger/nvim-lint'
        use {'aignas/nvim-lint', branch = 'feat/buildifier'}
        use 'neovim/nvim-lspconfig'
        use 'nvim-lua/plenary.nvim'
        use 'nvim-telescope/telescope.nvim'
        use 'rktjmp/lush.nvim'
        use 'tpope/vim-abolish'
        use 'tpope/vim-eunuch'
        use 'tpope/vim-fugitive'
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'
        use 'tpope/vim-unimpaired'
        use 'tyru/eskk.vim'
        use 'williamboman/mason.nvim'

        use {
            'nvim-treesitter/nvim-treesitter',
            run = [[:TSUpdateSync]],
        }
    end,
    config = {
        package_root = vim.env.XDG_CONFIG_HOME .. "/nvim/pack",
        plugin_package = "packer.nvim"
    }
})

require("mason").setup()

vim.cmd [[
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]]

actions = require("telescope.actions")
require("telescope").setup {
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_mru = true,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        },
        n = {
          ["<c-d>"] = actions.delete_buffer,
        }
      }
    },
    live_grep = {
      mappings = {
        i = {
          ["<c-l>"] = actions.send_to_loclist,
        },
        n = {
          ["<c-l>"] = actions.send_to_loclist,
        }
      }
    }
  }
}

require('lint').linters_by_ft = {
    bzl = {'buildifier'},
    py = {'ruff',},
    sh = {'shellcheck',},
    tf = {'tflint',},
    yaml = {'yamllint',},
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

vim.g.completion_enable_auto_popup = 0
vim.g.completion_enable_snippet = 'vim-vsnip'

vim.g.mapleader = ','
vim.g.maplocalleader = '-'
vim.g.vsnip_snippet_dir = os.getenv("XDG_CONFIG_HOME") .. '/nvim/vsnip'

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_markdown_css = vim.env.XDG_CONFIG_HOME .. '/nvim/styles/gdocs.css'

set_leader_mappings = function(mappings, prefix)
    prefix = prefix or ""

    for key, command in pairs(mappings) do
        key = prefix .. '<Leader>' .. key

        if (type(command) == "table") then
            set_leader_mappings(command, key)
        else
            vim.api.nvim_set_keymap('n', key, command, {noremap = true})
        end
    end
end

set_leader_mappings({
    WN = '<CMD>e ~/.notes/zettel/index.md<CR>',
    WW = '<CMD>e ~/.work/zettel/index.md<CR>',

    cd = '<CMD>lcd %:p:h<CR>',
    e = ':e %:h/',

    tF = '<CMD>Telescope find_files<CR>',
    tG = '<CMD>Telescope live_grep<CR>',
    tb = '<CMD>Telescope buffers<CR>',
    tB = '<CMD>Telescope git_branches<CR>',
    tf = '<CMD>Telescope git_files<CR>',
    ts = '<CMD>Telescope git_status<CR>',
    tg = '<CMD>Telescope grep_string<CR>',
    tq = '<CMD>Telescope quickfix<CR>',
    tl = '<CMD>Telescope loclist<CR>',
    z = '<CMD>e %:h/BUILD<CR>',
})

local remap = vim.api.nvim_set_keymap

require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "comment",
        "comment",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "hcl",
        "html",
        "ini",
        "java",
        "javascript",
        "jq",
        "jsdoc",
        "json",
        "jsonnet",
        "julia",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "php",
        "proto",
        "python",
        "ql",
        "query",
        "r",
        "regex",
        "rst",
        "rust",
        "sql",
        "starlark",
        "terraform",
        "toml",
        "typescript",
        "vim",
        "yaml",
        "zig",
    },
    highlight = {enable = true},
    indent = {enable = true},
    additional_vim_regex_highlighting = false,
}

vim.cmd [[
set guioptions=ag termguicolors lazyredraw
if exists('theme') && theme == 'light'
  set background=light
else
  set background=dark
endif
]]

vim.cmd.colorscheme "simple"

vim.opt.autoindent = true
vim.opt.backspace = "eol,start,indent"
vim.opt.backup = true
vim.opt.backupcopy = "yes"
vim.opt.backupdir:remove "."
vim.opt.breakindent = true
vim.opt.diffopt:append {"internal", "algorithm:patience", "vertical"}
vim.opt.directory:remove "."
vim.opt.expandtab = true
vim.opt.fileformats = { "unix", "mac", "dos"}
vim.opt.history = 10000
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 4
vim.opt.showbreak = "»»"
vim.opt.spell = true
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.whichwrap = 'b,s,<,>'
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = { "*.{hdl,ddl}" },
    command = [[set filetype=hive expandtab]],
})
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = { "init.lua" },
    command = [[PackerCompile]],
})

vim.o.grepprg = [[rg --vimgrep --no-heading -S]]
vim.o.grepformat = [[%f:%l:%c:%m,%f:%l:%m]]

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
on_attach = function(client, bufnr)
end

local function remap(key, cmd)
    vim.api.nvim_set_keymap('n', key, cmd, {noremap = true, silent = true})
end

remap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
remap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')

vim.g.tex_flavor = "latex"

vim.g.wiki_root = '~/.notes/zettel'
vim.g.wiki_journal = {
    name = '',
    frequency = 'daily',
    date_format = {
        daily = '%Y-%m-%d',
        weekly = '%Y_w%V',
        monthly = '%Y_m%m',
    },
}
vim.g.wiki_link_extension = '.md'
vim.g.wiki_link_target_type = 'md'
vim.g.wiki_filetypes = {'md'}
vim.g.wiki_mappings_use_defaults = 'global'
vim.g.wiki_mappings_local = {
    ['<plug>(wiki-graph-find-backlinks)'] = '<leader>wb',
    ['<plug>(wiki-graph-check-links)'] = '<leader>wlc',
    ['<plug>(wiki-graph-in)'] = '<leader>wg',
    ['<plug>(wiki-graph-out)'] = '<leader>wG',
    -- ['<plug>(wiki-link-next)'] = '<tab>',
    -- ['<plug>(wiki-link-prev)'] = '<s-tab>',
    ['<plug>(wiki-link-show)'] = '<leader>wll',
    ['<plug>(wiki-link-extract-header)'] = '<leader>wlh',
    ['<plug>(wiki-link-follow)'] = '<cr>',
    ['<plug>(wiki-link-follow-split)'] = '<c-w><cr>',
    ['<plug>(wiki-link-follow-tab)'] = '<c-w>u',
    ['<plug>(wiki-link-return)'] = '<bs>',
    ['<plug>(wiki-link-toggle)'] = '<leader>wf',
    ['<plug>(wiki-link-toggle-operator)'] = 'gl',
    ['<plug>(wiki-page-delete)'] = '<leader>wd',
    ['<plug>(wiki-page-rename)'] = '<leader>wr',
    ['<plug>(wiki-page-toc)'] = '<leader>wt',
    ['<plug>(wiki-page-toc-local)'] = '<leader>wT',
    ['<plug>(wiki-export)'] = '<leader>wp',
    ['x_<plug>(wiki-export)'] = '<leader>wp',
    ['<plug>(wiki-tag-list)'] = '<leader>wsl',
    ['<plug>(wiki-tag-reload)'] = '<leader>wsr',
    ['<plug>(wiki-tag-search)'] = '<leader>wss',
    ['<plug>(wiki-tag-rename)'] = '<leader>wsn',
    ['x_<plug>(wiki-link-toggle-visual)'] = '<cr>',
    ['o_<plug>(wiki-au)'] = 'au',
    ['x_<plug>(wiki-au)'] = 'au',
    ['o_<plug>(wiki-iu)'] = 'iu',
    ['x_<plug>(wiki-iu)'] = 'iu',
    ['o_<plug>(wiki-at)'] = 'at',
    ['x_<plug>(wiki-at)'] = 'at',
    ['o_<plug>(wiki-it)'] = 'it',
    ['x_<plug>(wiki-it)'] = 'it',
}
vim.g.wiki_mappings_local_journal = {
    ['<plug>(wiki-journal-prev)'] = '[w',
    ['<plug>(wiki-journal-next)'] = ']w',
    ['<plug>(wiki-journal-copy-tonext)'] = '<leader><c-n>',
    ['<plug>(wiki-journal-toweek)'] = '<leader>wu',
    ['<plug>(wiki-journal-tomonth)'] = '<leader>wm',
}
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_refresh_rate_idle = 5
vim.cmd [[
let g:wiki_map_link_create = 'MyFunction'
function MyFunction(text) abort
  return substitute(tolower(a:text), '\s\+', '-', 'g')
endfunction
]]

vim.g.lists_filetypes = {'md'}

require'eskk'.setup({
    start_completion_length = 2,
    directory = vim.env.XDG_DATA_HOME .. '/nvim/skk',
    select_cand_keys = 'aoeuhtns',
    show_annotation = 1,
    kakutei_when_unique_candidate = 1,
    log_cmdline_level = 2,
    log_file_level = 4,
    server = {
        host = '0.0.0.0',
        port = 1178
    }
})

for rc in string.gmatch(vim.env.EXTRA_NVIMRC or '', '[^:]+') do
    vim.cmd('exec "source' .. rc .. '"')
end
