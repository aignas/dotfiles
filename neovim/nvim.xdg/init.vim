" vim: filetype=vim

" vint: -ProhibitSetNoCompatible
set nocompatible
scriptencoding utf-8

let s:data_dir = $HOME . '/.local/share/nvim'
let g:python3_host_prog = s:data_dir . '/venv/bin/python'
let s:backup_dir = expand(s:data_dir . '/backups/')

call plug#begin(s:data_dir . '/plugged')

Plug 'itchyny/lightline.vim'
Plug 'junegunn/seoul256.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'w0rp/ale'
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'lotabout/skim.vim'
Plug 'tyru/eskk.vim', { 'for': ['markdown', 'vimwiki'] }
Plug 'fatih/vim-go', { 'for': ['markdown', 'go'], 'do': ':GoInstallBinaries' }
Plug 'rust-lang/rust.vim', { 'for': ['markdown', 'rust'],}
Plug 'vimwiki/vimwiki'
Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }

call plug#end()

" Required:
filetype plugin indent on
syntax enable
set history=10000

" Theming
set guioptions=ag laststatus=2 showtabline=2 noshowmode
set termguicolors background=dark
let g:seoul256_background = 235
colorscheme seoul256
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \     'left': [
      \         [ 'mode', 'eskk', 'paste' ],
      \         [ 'gitbranch', 'readonly', 'relativepath', 'modified' ],
      \     ],
      \     'right': [
      \         [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \         [ 'lineinfo' ],
      \         [ 'percent' ],
      \         [ 'fileformat', 'fileencoding', 'filetype' ],
      \     ],
      \ },
      \ 'component_expand': {
      \     'linter_checking': 'lightline#ale#checking',
      \     'linter_warnings': 'lightline#ale#warnings',
      \     'linter_errors': 'lightline#ale#errors',
      \     'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_function': {
      \     'gitbranch': 'fugitive#head',
      \     'eskk': 'eskk#statusline',
      \ },
      \ 'component_type': {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ },
      \ }

execute 'set backupdir=' . s:backup_dir . ',./.backup,.,/tmp'
execute 'set directory=' . s:backup_dir . ',.,./.backup,/tmp'
set autoindent
set backspace=eol,start,indent
set backup backupcopy=yes
set breakindent showbreak=»»
set expandtab shiftwidth=4 tabstop=4
set fileformats=unix,dos
set foldenable foldlevel=1
set hidden
set incsearch hlsearch
set joinspaces cpoptions+=J     " Double spacing between sentences
set lazyredraw
set linebreak
set list
set magic
set number relativenumber
set pastetoggle=<F2>
set spell                       " vim-unimpaired: use [os and ]os
set undofile
set whichwrap+=<,>
set wrap
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

iabbrev xtodo TODO @aignas (<c-r>=strftime("%Y-%m-%d")<cr>):
iabbrev xtime <c-r>=strftime("%Y-%m-%d %H:%M:%S")<cr>:
iabbrev xdate <c-r>=strftime("%Y-%m-%d")<cr>:

let g:mapleader=','
let g:maplocalleader='-'
nnoremap <leader>a :grep <end>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>gf :GFiles<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>dd :ALEGoToDefinition<CR>
nnoremap <silent> <leader>ds :ALEGoToDefinitionInSplit<CR>
nnoremap <silent> <leader>h :ALEHover<CR>
nnoremap <silent> <leader>vc :e $MYVIMRC<cr>
nnoremap <silent> <leader>vv :source $MYVIMRC<cr>:echo "init.vim reloaded"<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader><leader> :wa<cr>:echo "Everything saved"<cr>
nnoremap <silent> <leader>cd :cd %:p:h<cr>

let g:ale_fix_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = {
    \   'go': ['gometalinter', 'bingo'],
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

let g:markdown_composer_autostart=1
let g:markdown_composer_browser='dot-open'
let g:markdown_composer_open_browser=0

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
