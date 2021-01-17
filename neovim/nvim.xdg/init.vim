" vim: filetype=vim
scriptencoding utf-8

function! Pack() abort
    packadd minpac

    " minpac is loaded.
    call minpac#init()

    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})
    call minpac#add('https://git.sr.ht/~romainl/vim-bruin')
    call minpac#add('junegunn/fzf', {
                \ 'do': '!./install --xdg --no-update-rc',
                \})
    call minpac#add('junegunn/fzf.vim')
    call minpac#add('tpope/vim-fugitive')
    call minpac#add('tpope/vim-abolish')
    call minpac#add('tpope/vim-repeat')
    call minpac#add('tpope/vim-surround')
    call minpac#add('tpope/vim-unimpaired')

    call minpac#add('joereynolds/vim-minisnip')
    call minpac#add('sbdchd/neoformat')

    call minpac#add('cappyzawa/starlark.vim')
    call minpac#add('vimwiki/vimwiki')
    call minpac#add('lervag/vimtex')
    call minpac#add('rust-lang/rust.vim')
    call minpac#add('fatih/vim-go')
    call minpac#add('autowitch/hive.vim')
    call minpac#add('tyru/eskk.vim')
    call minpac#add('euclio/vim-markdown-composer', {
                \ 'do': '!cargo build --release --locked',
                \})

    call minpac#add('autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': '!./install.sh',
                \ 'type': 'opt',
                \ })

    call minpac#update()
    call minpac#clean()
endfunction

" Use opt so that I can have support for neovim 0.5 in a branch more easily so
" that incompatible plugins are optional
packadd LanguageClient-neovim

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! Pack call Pack()

if $XDG_CONFIG_HOME ==# ''
    let $XDG_CONFIG_HOME = $HOME . '/.config'
endif
if $XDG_DATA_HOME ==# ''
    " Make vimr work in case XDG_DATA_HOME is not set
    let $XDG_DATA_HOME = $HOME . '/.local/share'
endif

set guioptions=ag termguicolors lazyredraw
colorscheme bruin

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
set scrolloff=5

if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ -S
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

let g:mapleader=','
let g:maplocalleader='-'
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>cd :cd %:p:h<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>ss :Gstatus<cr>
nnoremap <leader>gg :!tdd
nnoremap <leader>e :e %:h/
nnoremap <silent> <leader>z :e %:h/BUILD.bazel<cr>

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ }

nmap <leader>gd <plug>(lcn-definition)
nmap <leader>ga <plug>(lcn-code-action)
nmap <leader>gA <plug>(lcn-code-lens-action)
nmap <leader>gm <plug>(lcn-menu)
nmap <leader>gh <plug>(lcn-hover)
nmap <leader>gi <plug>(lcn-implementation)
nmap <leader>gr <plug>(lcn-references)
nmap <leader>gs <plug>(lcn-workspace-symbol)
nmap <leader>gR <plug>(lcn-rename)
nmap <leader>gH <plug>(lcn-signature-help)
nmap <leader>gD <plug>(lcn-type-definition)

au BufNewFile,BufRead *.hql set filetype=hive expandtab
au BufNewFile,BufRead *.ddl set filetype=hive expandtab

augroup fmt
    autocmd!
    autocmd BufWritePre *.{sh,go,rs} Neoformat
augroup END

let g:go_template_autocreate = 0
let g:go_version_warning = 0


let g:neoformat_run_all_formatters = 1
let g:neoformat_basic_format_trim = 1

let g:tex_flavor = "latex"

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
