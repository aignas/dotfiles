" vim: filetype=vim
scriptencoding utf-8

let g:plug_url_format='git@github.com:%s.git'
if $XDG_CONFIG_HOME ==# ''
    let $XDG_CONFIG_HOME = $HOME . '/.config'
endif
if $XDG_DATA_HOME ==# ''
    " Make vimr work in case XDG_DATA_HOME is not set
    let $XDG_DATA_HOME = $HOME . '/.local/share'
endif
call plug#begin('$XDG_DATA_HOME/nvim/plugged')
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'cappyzawa/starlark.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'dense-analysis/ale'
Plug 'joereynolds/vim-minisnip'
Plug 'vimwiki/vimwiki'
Plug 'lervag/vimtex', {'for': ['tex']}
Plug 'rust-lang/rust.vim', {'for': ['rust', 'markdown']}
Plug 'arp242/gopher.vim', {'for': ['go', 'markdown']}
Plug 'tyru/eskk.vim', {'for': ['markdown']}
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }

function! BuildComposer(info)
    if a:info.status !=# 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release --locked
        else
            !cargo build --release --locked --no-default-features --features json-rpc
        endif
    endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
call plug#end()

let g:seoul256_background = 235
colorscheme seoul256
set guioptions=ag termguicolors lazyredraw

if has('patch-8.1.0360')
    set diffopt+=internal,algorithm:patience
endif

set backupdir-=.
set directory-=.
set history=10000 undofile backup backupcopy=yes
set backspace=eol,start,indent
set autoindent breakindent showbreak=»»
set expandtab shiftwidth=4 tabstop=4
set fileformats=unix,mac,dos
set linebreak
set list
set number relativenumber
set spell                       " vim-unimpaired: use [os and ]os
set whichwrap+=<,>
set cpoptions+=J                " Double spacing between sentences

if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ -S
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

iabbrev xtodo TODO @aignas (<c-r>=strftime("%Y-%m-%d")<cr>)
iabbrev xfix  FIXME @aignas (<c-r>=strftime("%Y-%m-%d")<cr>)
iabbrev xtime <c-r>=strftime("%Y-%m-%d %H:%M:%S")<cr>:
iabbrev xdate <c-r>=strftime("%Y-%m-%d")<cr>:

let g:mapleader=','
let g:maplocalleader='-'
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>cd :cd %:p:h<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <leader>e :e %:h/
nnoremap <silent> <leader>z :e %:h/BUILD.bazel<cr>

set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

"let g:LanguageClient_loggingFile = expand('~/.local/share/nvim/LanguageClient.log')
"let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'stable', 'rls'],
            \ 'go': ['gopls'],
            \ }
nnoremap <silent> <leader>gd :call LanguageClient#textDocument_definition()<cr>
nnoremap <silent> <leader>gh :call LanguageClient#textDocument_hover()<cr>
nnoremap <silent> <leader>gi :call LanguageClient#textDocument_implementation()<cr>
nnoremap <silent> <leader>gr :call LanguageClient#textDocument_references()<cr>
nnoremap <silent> <leader>gs :call LanguageClient#textDocument_documentSymbol()<cr>
nnoremap <silent> <leader>gR :call LanguageClient#textDocument_rename()<cr>
nnoremap <silent> <leader>gH :call LanguageClient#textDocument_signatureHelp()<cr>
nnoremap <silent> <leader>gD :call LanguageClient#textDocument_typeDefinition()<cr>

let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}

let g:vimwiki_folding='expr'
let g:vimwiki_list = [{'path': '~/vimwiki2/content',
            \ 'syntax': 'markdown',
            \ 'index': '_index',
            \ 'diary_index': '_index',
            \ 'ext': '.md',
            \ }]

let g:eskk#start_completion_length=2
let g:eskk#directory = $XDG_DATA_HOME . '/nvim/skk'
let g:eskk#select_cand_keys = 'aoeuhtns'
let g:eskk#show_annotation = 1
let g:eskk#kakutei_when_unique_candidate = 1

let s:skk = $XDG_DATA_HOME . '/nvim/skk'
if finddir('/usr/share/skk')
    let s:skk = '/usr/share/skk'
endif
let g:eskk#dictionary =       {'path': s:skk . '/skk-jisyo.s', }
let g:eskk#large_dictionary = {'path': s:skk . '/SKK-JISYO.L'}

let g:minisnip_dir = $XDG_CONFIG_HOME . '/nvim/minisnip'
