" vim: filetype=vim
scriptencoding utf-8

if exists('*minpac#init')
    " minpac is loaded.
    call minpac#init()

    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})
    call minpac#add('junegunn/seoul256.vim')
    call minpac#add('junegunn/fzf', {
                \ 'do': '!./install --64 --xdg --no-update-rc',
                \})
    call minpac#add('junegunn/fzf.vim')
    call minpac#add('AndrewRadev/splitjoin.vim')
    call minpac#add('cappyzawa/starlark.vim')
    call minpac#add('tpope/vim-fugitive')
    call minpac#add('tpope/vim-abolish')
    call minpac#add('tpope/vim-repeat')
    call minpac#add('tpope/vim-surround')
    call minpac#add('dense-analysis/ale')
    call minpac#add('prabirshrestha/async.vim')
    call minpac#add('prabirshrestha/vim-lsp')
    call minpac#add('mattn/vim-lsp-settings')
    call minpac#add('joereynolds/vim-minisnip')
    call minpac#add('vimwiki/vimwiki')
    call minpac#add('lervag/vimtex')
    call minpac#add('rust-lang/rust.vim')
    call minpac#add('arp242/gopher.vim')
    call minpac#add('tyru/eskk.vim')
endif

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! Pack packadd minpac | source $MYVIMRC | call minpac#update() | call minpac#clean()

if $XDG_CONFIG_HOME ==# ''
    let $XDG_CONFIG_HOME = $HOME . '/.config'
endif
if $XDG_DATA_HOME ==# ''
    " Make vimr work in case XDG_DATA_HOME is not set
    let $XDG_DATA_HOME = $HOME . '/.local/share'
endif

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

let g:mapleader=','
let g:maplocalleader='-'
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>cd :cd %:p:h<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>ss :Gstatus<cr>
nnoremap <leader>e :e %:h/
nnoremap <silent> <leader>z :e %:h/BUILD.bazel<cr>

"let g:lsp_log_file = expand('~/.local/share/nvim/vim-lsp.log')
augroup lsp_install
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->[$XDG_CONFIG_HOME . '/nvim/pack/minpac/start/gopher.vim/tools/bin/gopls']},
        \ 'whitelist': ['go'],
        \ })
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })

    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 0
let g:lsp_preview_max_height = 3
"let g:lsp_signature_help_enabled = 0
set previewheight=5

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gh <plug>(lsp-hover)
    nmap <buffer> <leader>gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gr <plug>(lsp-references)
    nmap <buffer> <leader>gs <plug>(lsp-workspace-symbol)
    nmap <buffer> <leader>gR <plug>(lsp-rename)
    nmap <buffer> <leader>gH <plug>(lsp-signature-help)
    nmap <buffer> <leader>gD <plug>(lsp-type-definition)
endfunction

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
