" vim: filetype=vim

" vint: -ProhibitSetNoCompatible
set nocompatible
scriptencoding utf-8

let s:data_dir = $HOME . '/.local/share/nvim'
let g:python3_host_prog = s:data_dir . '/venv/bin/python'
let s:backup_dir = expand(s:data_dir . '/backups/')

call plug#begin(s:data_dir . '/plugged')

Plug 'junegunn/seoul256.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'w0rp/ale'
Plug 'lotabout/skim'
Plug 'lotabout/skim.vim'
Plug 'tyru/eskk.vim', { 'for': ['markdown', 'vimwiki'] }
Plug 'fatih/vim-go', { 'for': ['markdown', 'go'], 'do': ':GoInstallBinaries' }
Plug 'rust-lang/rust.vim', { 'for': ['markdown', 'rust'],}
Plug 'vimwiki/vimwiki'

call plug#end()

" Required:
filetype plugin indent on
syntax enable
set history=10000

" Theming
set guioptions=ag termguicolors lazyredraw background=dark
let g:seoul256_background = 235
colorscheme seoul256

execute 'set backupdir=' . s:backup_dir . ',./.backup,.,/tmp'
execute 'set directory=' . s:backup_dir . ',.,./.backup,/tmp'
set undofile backup backupcopy=yes
set backspace=eol,start,indent
set autoindent breakindent showbreak=»»
set expandtab shiftwidth=4 tabstop=4
set fileformats=unix,mac,dos
set cpoptions+=J                " Double spacing between sentences
set linebreak
set list
set number relativenumber
set spell                       " vim-unimpaired: use [os and ]os
set whichwrap+=<,>

if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

iabbrev xtodo TODO @aignas (<c-r>=strftime("%Y-%m-%d")<cr>)
iabbrev xfix  FIXME @aignas (<c-r>=strftime("%Y-%m-%d")<cr>)
iabbrev xtime <c-r>=strftime("%Y-%m-%d %H:%M:%S")<cr>:
iabbrev xdate <c-r>=strftime("%Y-%m-%d")<cr>:

let g:mapleader=','
nnoremap <silent> <leader><leader> :wa<cr>:echo "Everything saved"<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>cd :cd %:p:h<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>gd :ALEGoToDefinition<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gt :ALEGoToTypeDefinition<cr>
nnoremap <silent> <leader>h :ALEHover<cr>
nnoremap <leader>e :e %:p:h
set omnifunc=ale#completion#OmniFunc

let g:ale_fix_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = {
    \   'go': ['golangci-lint', 'gopls'],
    \   'rust': ['rls', 'cargo'],
    \   'javascript': ['eslint'],
    \}
let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'rust': ['rustfmt'],
    \   'go': ['gofmt', 'goimports'],
    \   'javascript': ['eslint', 'prettier_eslint', 'importjs'],
    \}

let g:vimwiki_folding='expr'
let g:vimwiki_list = [{'path': '~/vimwiki',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ }]

let g:eskk#start_completion_length=2
let g:eskk#directory = s:data_dir . '/skk'
let g:eskk#dictionary = {
    \   'path': s:data_dir . '/skk/skk-jisyo.s',
    \   'sorted': 0,
    \   'encoding': 'utf-8',
    \}
let g:eskk#large_dictionary = {
    \   'path': s:data_dir . '/skk/SKK-JISYO.L',
    \   'sorted': 1,
    \   'encoding': 'euc-jp',
    \}
