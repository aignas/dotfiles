if vim.env.XDG_CONFIG_HOME == nil then
    vim.env.XDG_CONFIG_HOME = vim.env.HOME .. '/.config'
end
if vim.env.XDG_DATA_HOME == nil then
    vim.env.XDG_DATA_HOME = vim.env.HOME .. '/.local/share'
end

local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()
require('pckr').add{
    {
      'lewis6991/pckr.nvim',
      branch = 'main',
      opt = true,
    };

    'hrsh7th/cmp-buffer';
    'hrsh7th/cmp-cmdline';
    'hrsh7th/cmp-nvim-lsp';
    'hrsh7th/cmp-path';
    'hrsh7th/nvim-cmp';
    'hrsh7th/vim-vsnip';
    'hrsh7th/vim-vsnip-integ';
    'lervag/lists.vim';
    'lervag/wiki.vim';
    'mfussenegger/nvim-dap';
    'mfussenegger/nvim-lint';
    'neovim/nvim-lspconfig';
    { 'nvim-telescope/telescope.nvim',
      requires = {'nvim-lua/plenary.nvim'},
    };
    'rktjmp/lush.nvim';
    'tpope/vim-abolish';
    'tpope/vim-eunuch';
    'tpope/vim-fugitive';
    'tpope/vim-repeat';
    'tpope/vim-surround';
    'tpope/vim-unimpaired';

    { 'vim-skk/skkeleton',
      requires = {'vim-denops/denops.vim'},
    };
}

vim.cmd [[
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
tmap <C-j> <Plug>(skkeleton-toggle)
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

vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged" }, {
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
    WN = '<CMD>e ~/.notes/content/index.md<CR>',
    WW = '<CMD>e ~/.work/zettel/index.md<CR>',
    ww = '<CMD>WikiJournal<CR>',

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

-- require'nvim-treesitter.configs'.setup {
--     highlight = {enable = true},
--     indent = {enable = true},
--     additional_vim_regex_highlighting = false,
-- }

vim.cmd [[
set guioptions=ag termguicolors lazyredraw
set background=light
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

vim.g.wiki_root = '~/.notes'
vim.g.wiki_journal = {
    name = 'journal',
    root = '',
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
    ['<plug>(wiki-link-transform)'] = '<leader>wf',
    ['<plug>(wiki-link-transform-operator)'] = 'gl',
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
    ['x_<plug>(wiki-link-transform-visual)'] = '<cr>',
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
vim.g.wiki_link_creation = {
    md = {
        link_type = 'md',
        url_extension = '.md',
        url_transform = function(x)
            return "content/" .. vim.fn.substitute(x, '\\[\\s\\]\\+', '-', 'g')
        end
    },
    ['_'] = {
        link_type = 'md',
        url_extension = '.md',
        url_transform = function(x)
            return "unknown link type"
        end
    },
}

vim.g.lists_filetypes = {'md'}


-- TODO @aignas 2023-10-15: configure the eskk to use nix managed dicts
vim.cmd [[
call skkeleton#config({
    \ 'globalDictionaries': ["~/.nix-profile/share/SKK-JISYO.L"],
    \ 'selectCandidateKeys': 'aoeuhtns',
    \})
]]

for rc in string.gmatch(vim.env.EXTRA_NVIMRC or '', '[^:]+') do
    vim.cmd('exec "source' .. rc .. '"')
end
