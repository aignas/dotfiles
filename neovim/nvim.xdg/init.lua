if vim.env.XDG_CONFIG_HOME == nil then
    vim.env.XDG_CONFIG_HOME = vim.env.HOME .. '/.config'
end
if vim.env.XDG_DATA_HOME == nil then
    vim.env.XDG_DATA_HOME = vim.env.HOME .. '/.local/share'
end

-- TODO @aignas 2021-03-28: once I have a working luarocks setup on my Linux
-- mashine, I can use the `posix` support to check for directories.
--
-- require 'posix'
-- function isdir(fn)
--     return (posix.stat(fn, "type") == 'directory')
-- end

vim.cmd [[packadd packer.nvim]]
require('packer').startup({function()
    use {'wbthomason/packer.nvim', opt = true}

    use 'rktjmp/lush.nvim'

    use 'tpope/vim-abolish'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'

    use {
        'junegunn/fzf.vim',
        requires = {{
            'junegunn/fzf',
            run = [[./install --xdg --no-update-rc]],
        }}
    }

    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'

    use 'autowitch/hive.vim'
    use 'cappyzawa/starlark.vim'
    use 'fatih/vim-go'
    use 'lervag/vimtex'
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'
    use 'rust-lang/rust.vim'
    use 'tyru/eskk.vim'
    use 'vimwiki/vimwiki'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = [[:TSUpdate]],
    }
    use {
        'euclio/vim-markdown-composer',
        run = [[cargo build --release --locked]],
    }
end,
config = {
    package_root = "/home/aignas/.config/nvim/pack",
    plugin_package = "packer.nvim",
}})

vim.cmd [[
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]]

vim.g.completion_enable_auto_popup = 0
vim.g.mapleader = ","
vim.g.maplocalleader = '-'
vim.g.vsnip_snippet_dir = os.getenv("XDG_CONFIG_HOME") .. '/nvim/vsnip'

local remap = vim.api.nvim_set_keymap
remap("n", "<Leader>b", "<CMD>Buffers<CR>", { noremap = true })
remap("n", "<Leader>f", "<CMD>Files<CR>", { noremap = true })
remap("n", "<Leader>e", ":e %:h/", { noremap = true })
remap("n", "<Leader>ss", "<CMD>Gstatus<CR>", { noremap = true })
remap("n", "<Leader>gg", ":!tdd ", { noremap = true })
remap("n", "<Leader>cd", "<CMD>cd %:p:h<CR>", { noremap = true })
remap("n", "<Leader>z", "<CMD>e %:h/BUILD.bazel<CR>", { noremap = true })

require 'nvim-treesitter.configs'.setup {
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
    highlight = { enable = true },
    indent = { enable = true }
}

vim.cmd [[
set guioptions=ag termguicolors lazyredraw
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
set cpoptions+=J
set scrolloff=5

autocmd BufNewFile,BufRead *.{hql,ddl} set filetype=hive expandtab
autocmd BufWritePost init.lua PackerCompile
]]

vim.o.grepprg=[[rg --vimgrep --no-heading -S]]
vim.o.grepformat=[[%f:%l:%c:%m,%f:%l:%m]]

-- LSP
local on_attach = function(client, bufnr)
    require('completion').on_attach()

    local function remap(key, cmd)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, cmd, {noremap=true, silent=true})
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

local nvim_lsp = require('lspconfig')
local servers = {'gopls', 'rust_analyzer', 'sqls'}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
    }
end

vim.g.tex_flavor = "latex"
vim.g.vimwiki_folding = 'expr'
vim.g.vimwiki_list = {{
    path        = '~/vimwiki2/content',
    syntax      = 'markdown',
    index       = '_index',
    diary_index = '_index',
    ext         = '.md',
}}

function eskk(key, val)
    vim.g['eskk#' .. key ] = val
end

eskk('start_completion_length', 2)
vim.cmd [[
let g:eskk#directory = $XDG_DATA_HOME . '/nvim/skk'
let g:eskk#select_cand_keys = 'aoeuhtns'
let g:eskk#show_annotation = 1
let g:eskk#kakutei_when_unique_candidate = 1

let g:skk_path = $XDG_DATA_HOME . '/nvim/skk'
if finddir('/usr/share/skk')
    let g:skk_path = '/usr/share/skk'
endif
let g:eskk#dictionary =       {'path': g:skk_path . '/skk-jisyo.s', }
let g:eskk#large_dictionary = {'path': g:skk_path . '/SKK-JISYO.L'}
]]
