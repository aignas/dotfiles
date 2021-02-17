if vim.env.XDG_CONFIG_HOME == nil then
    vim.env.XDG_CONFIG_HOME = vim.env.HOME .. '/.config'
end
if vim.env.XDG_DATA_HOME == nil then
    vim.env.XDG_DATA_HOME = vim.env.HOME .. '/.local/share'
end

vim.cmd [[packadd packer.nvim]]
require('packer').startup({function()
    use {'wbthomason/packer.nvim', opt = true}

    use 'rktjmp/lush.nvim'

    use 'tpope/vim-fugitive'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-abolish'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-eunuch'

    use {
        'junegunn/fzf.vim',
        requires = {{
            'junegunn/fzf',
            run = [[./install --xdg --no-update-rc]],
        }}
    }

    use 'joereynolds/vim-minisnip'
    use 'sbdchd/neoformat'

    use 'cappyzawa/starlark.vim'
    use 'vimwiki/vimwiki'
    use 'lervag/vimtex'
    use 'rust-lang/rust.vim'
    use 'fatih/vim-go'
    use 'autowitch/hive.vim'
    use 'tyru/eskk.vim'
    use {
        'euclio/vim-markdown-composer',
        run = [[cargo build --release --locked]]
    }

    -- legacy plugins to manage, but not enable
    use {'autozimu/LanguageClient-neovim', opt = true}
    use {'k-takata/minpac', opt = true, as = 'minpac'}

    -- plugins that need 0.5+
    use {'nvim-treesitter/nvim-treesitter', run = "TSUpdate", opt = true}
    use {'neovim/nvim-lspconfig', opt = true}
    use {'nvim-lua/completion-nvim', opt = true}
end,
config = {
    package_root = "/home/aignas/.config/nvim/pack",
    plugin_package = "minpac",
}})

vim.cmd [[packadd nvim-treesitter]]
vim.cmd [[packadd nvim-lspconfig]]
vim.cmd [[packadd completion-nvim]]
vim.cmd [[let g:completion_enable_auto_popup = 0]]

vim.g.mapleader = ","
vim.g.maplocalleader = '-'

local remap = vim.api.nvim_set_keymap
remap("n", "<Leader>b", "<CMD>Buffers<CR>", { noremap = true })
remap("n", "<Leader>f", "<CMD>Files<CR>", { noremap = true })
remap("n", "<Leader>e", ":e %:h/", { noremap = true })
remap("n", "<Leader>ss", "<CMD>Gstatus<CR>", { noremap = true })
remap("n", "<Leader>gg", ":!tdd ", { noremap = true })
remap("n", "<Leader>cd", "<CMD>cd %:p:h<CR>", { noremap = true })
remap("n", "<Leader>z", "<CMD>e %:h/BUILD.bazel<CR>", { noremap = true })

require 'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
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

let g:neoformat_verbose = 1

autocmd BufNewFile,BufRead *.{hql,ddl} set filetype=hive expandtab
autocmd BufWritePost init.lua PackerCompile
autocmd BufWritePre *.{rs,go,lua,sh} Neoformat

if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ -S
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
]]

-- [[ LSP ]]
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
local servers = {'gopls', 'rust_analyzer'}
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

vim.cmd [[
let g:eskk#start_completion_length=2
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

vim.api.nvim_set_var("minisnip_dir", os.getenv("XDG_CONFIG_HOME") .. '/nvim/minisnip')
