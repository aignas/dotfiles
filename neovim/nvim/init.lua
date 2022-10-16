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
        use 'shaunsingh/seoul256.nvim'

        use 'tpope/vim-abolish'
        use 'tpope/vim-eunuch'
        use {
            'tpope/vim-fugitive',
            requires = {
                {'tpope/vim-rhubarb'},
            }
        }
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
        use 'williamboman/nvim-lsp-installer'
        use 'hrsh7th/vim-vsnip'
        use 'hrsh7th/vim-vsnip-integ'
        use 'gpanders/editorconfig.nvim'

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
            run = [[:TSUpdateSync]],
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

require('editorconfig').properties.foo = function(bufnr, val)
  vim.b[bufnr].foo = val
end

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
    z = '<CMD>e %:h/BUILD<CR>',
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
      "hcl",
      "html",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "julia",
      "lua",
      "markdown",
      "markdown_inline",
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
      "vim",
      "yaml",
      "zig",
    },
    highlight = {enable = true},
    indent = {enable = true}
}

vim.cmd [[
set guioptions=ag termguicolors lazyredraw
if exists('theme') && theme == 'light'
  set background=light
else
  set background=dark
endif

let g:seoul256_italic_comments = v:true
let g:seoul256_italic_keywords = v:true
let g:seoul256_italic_functions = v:true
let g:seoul256_italic_variables = v:false
let g:seoul256_contrast = v:true
let g:seoul256_borders = v:false
let g:seoul256_disable_background = v:false
let g:seoul256_hl_current_line = v:true

colorscheme simple

set diffopt+=internal,algorithm:patience
set history=10000 undofile backup backupcopy=yes
set backupdir-=.
set directory-=.
set backspace=eol,start,indent
set autoindent breakindent showbreak=»»
set expandtab shiftwidth=4 tabstop=4
set fileformats=unix,mac,dos
set laststatus=3
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
on_attach = function(client, bufnr)
    require('completion').on_attach()

    local function remap(key, cmd)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, cmd,
                                    {noremap = true, silent = true})
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    remap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    remap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    remap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    remap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    remap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    remap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    remap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    remap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
    remap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    remap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    remap('<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    remap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    remap('<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
    remap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    remap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    remap('<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
    remap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    server:setup({on_attach = on_attach})
end)

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
vim.cmd [[
let g:neovide_cursor_animation_length=0.01
let g:neovide_refresh_rate_idle=5
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
