if vim.env.XDG_CONFIG_HOME == nil then
    vim.env.XDG_CONFIG_HOME = vim.env.HOME .. '/.config'
end
if vim.env.XDG_DATA_HOME == nil then
    vim.env.XDG_DATA_HOME = vim.env.HOME .. '/.local/share'
end

vim.cmd [[packadd packer.nvim]]
require('packer').startup({
    function()
        use {
            'wbthomason/packer.nvim',
            branch = 'master',
            opt = true,
        }

        use 'rktjmp/lush.nvim'

        use 'tpope/vim-abolish'
        use 'tpope/vim-eunuch'
        use 'tpope/vim-fugitive'
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'
        use 'tpope/vim-unimpaired'

        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                {'nvim-lua/popup.nvim'},
                {'nvim-lua/plenary.nvim'},
            }
        }

        use 'neovim/nvim-lspconfig'
        use 'kabouzeid/nvim-lspinstall'
        use 'hrsh7th/vim-vsnip'
        use 'plasticboy/vim-markdown'
        use 'hrsh7th/vim-vsnip-integ'
        use 'sbdchd/neoformat'

        use 'autowitch/hive.vim'
        use 'cappyzawa/starlark.vim'
        use 'fatih/vim-go'
        use 'lervag/vimtex'
        use 'lervag/wiki.vim'
        use 'godlygeek/tabular'
        use 'lervag/lists.vim'
        use 'nvim-lua/completion-nvim'
        use 'rust-lang/rust.vim'
        use 'tyru/eskk.vim'

        use {
            'nvim-treesitter/nvim-treesitter',
            run = [[:TSUpdate]],
        }
        use {
            'iamcco/markdown-preview.nvim',
            run = [[:call mkdp#util#install()]]
        }
    end,
    config = {
        package_root = vim.env.XDG_CONFIG_HOME .. "/nvim/pack",
        plugin_package = "packer.nvim"
    }
})

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
      sort_lastused = true,
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


vim.g.completion_enable_auto_popup = 0
vim.g.completion_enable_snippet = 'vim-vsnip'

vim.g.mapleader = ','
vim.g.maplocalleader = '-'
vim.g.vsnip_snippet_dir = os.getenv("XDG_CONFIG_HOME") .. '/nvim/vsnip'

vim.g.neoformat_run_all_formatters = 1

vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_auto_insert_bullets = 0

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
    gg = ':!tdd ',
    ss = '<CMD>Gstatus<CR>',

    tF = '<CMD>Telescope find_files<CR>',
    tG = '<CMD>Telescope live_grep<CR>',
    tb = '<CMD>Telescope buffers<CR>',
    tB = '<CMD>Telescope git_branches<CR>',
    tf = '<CMD>Telescope git_files<CR>',
    ts = '<CMD>Telescope git_status<CR>',
    tg = '<CMD>Telescope grep_string<CR>',
    tq = '<CMD>Telescope quickfix<CR>',
    tl = '<CMD>Telescope loclist<CR>',
    w = {
        m = '<CMD>WikiJournalNext<CR>',
        y = '<CMD>WikiJournalPrev<CR>',
    },
    z = '<CMD>e %:h/BUILD.bazel<CR>',
})

local remap = vim.api.nvim_set_keymap


require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "bash",
      "c",
      "c_sharp",
      "comment",
      "cpp",
      "css",
      "go",
      "graphql",
      "html",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "julia",
      "lua",
      "php",
      "python",
      "ql",
      "query",
      "r",
      "regex",
      "rst",
      "rust",
      "toml",
      "typescript",
      "yaml",
      "zig",
    },
    highlight = {enable = true},
    indent = {enable = true}
}

vim.cmd [[
set guioptions=ag termguicolors lazyredraw
set background=light
colorscheme simple

set diffopt+=internal,algorithm:patience
set history=10000 undofile backup backupcopy=yes
set backupdir-=.
set directory-=.
set backspace=eol,start,indent
set autoindent breakindent showbreak=»»
set expandtab shiftwidth=4 tabstop=4
set fileformats=unix,mac,dos
set linebreak list number
set nospell
set whichwrap+=<,>
set scrolloff=5

autocmd BufNewFile,BufRead *.{hql,ddl} set filetype=hive expandtab
autocmd BufWritePost init.lua PackerCompile
]]

vim.o.grepprg = [[rg --vimgrep --no-heading -S]]
vim.o.grepformat = [[%f:%l:%c:%m,%f:%l:%m]]

-- LSP
local on_attach = function(client, bufnr)
    require('completion').on_attach()

    vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)]]

    local function remap(key, cmd)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, cmd,
                                    {noremap = true, silent = true})
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    remap('<leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
    remap('<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
    remap('<leader>gh', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    remap('<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    remap('<leader>gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    remap('<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    remap('<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    remap('<leader>gR', '<cmd>lua vim.lsp.buf.rename()<CR>')
    remap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    remap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    remap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    remap('<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
end

local function setup_servers()
    require'lspinstall'.setup()
    local servers = require'lspinstall'.installed_servers()
    local nvim_lsp = require('lspconfig')
    for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup {on_attach = on_attach} end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

vim.g.tex_flavor = "latex"

vim.g.wiki_root = '~/.work/zettel'
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
