" vim: filetype=vim
"
" Neovim/Vim configuration by Ignas Anikevičius
"
" There are numerous people, whose configuration files were copied and adapted
" and it's hard to list everybody, but the main ones are:
"
"   * Amir Salihefendic <amix3k at gmail.com>
"       http://amix.dk/blog/post/19486#The-ultimative-Vim-configuration-vimrc
"
"   * Steve Losh
"       http://stevelosh.com/blog/2010/09/coming-home-to-vim/#
"
"   * Neovim project defaults

scriptencoding utf-8
" Set no compatible on purpose
" vint: -ProhibitSetNoCompatible
set nocompatible

if has('nvim')
    let s:data_dir = $HOME . '/.local/share/nvim'
else
    let s:data_dir = $HOME . '/.local/share/vim'
endif
let g:python3_host_prog = s:data_dir . '/venv/bin/python'
let s:backup_dir = expand(s:data_dir . '/backups/')

call plug#begin(s:data_dir . '/plugged')

Plug 'haya14busa/vim-asterisk'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/seoul256.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'janko-m/vim-test'
Plug 'w0rp/ale'
Plug 'tyru/eskk.vim', { 'for': 'markdown' }
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'lotabout/skim.vim'

Plug 'fatih/vim-go', { 'for': ['markdown', 'go'], 'do': ':GoInstallBinaries' }
Plug 'rust-lang/rust.vim', { 'for': ['markdown', 'rust'],}
Plug 'vmchale/ion-vim', { 'for': ['markdown', 'ion'],}
Plug 'vimwiki/vimwiki'

function! BuildComposer(info)
    if a:info.status !=# 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release
        else
            !cargo build --release --no-default-features --features json-rpc
        endif
    endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

call plug#end()

"Generate help tags
silent! helptags ALL

" Generic vim {{{
" Required:
filetype plugin indent on
syntax enable               " Enable syntax hl
set history=10000           " History size
let g:mapleader=','         " Change the def leader
let g:maplocalleader='-'    " Change the def leader

" Theming
set guioptions=ag           " remove toolbar, menubar and graphical tabs
colorscheme seoul256
"let g:seoul256_background = 235
set background=dark
set laststatus=2 showtabline=2 noshowmode
let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
        \ },
        \ 'component_function': {'gitbranch': 'fugitive#head'},
        \ 'colorscheme': 'seoul256',
        \ }

set fileformats=unix,dos
augroup general_settings
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
    autocmd FocusLost * :wa          " Save when loosing focus
augroup END

set cmdheight=2                  " The command bar is 2 high
set number relativenumber        " Show relative line numbers, with the current absolute
set lazyredraw                   " Do not redraw, when running macros: lazy redraw
set hidden                       " Change buffer - without saving
set backspace=eol,start,indent   " Set backspace
set autoindent                   " Set auto-indent
set whichwrap+=<,>               " Backspace and cursor keys wrap to
set incsearch hlsearch           " Highlight search results
set magic                        " Set magic on
set list
set breakindent showbreak=»»
set path+=** wildmode=full

nnoremap <silent> <leader><leader> :wa<cr>:echo "Everything saved"<cr>
nnoremap <silent> <leader>cd :cd %:p:h<cr>

set backup
set backupcopy=yes
set undofile
execute 'set backupdir=' . s:backup_dir . ',./.backup,.,/tmp'
execute 'set directory=' . s:backup_dir . ',.,./.backup,/tmp'
set foldenable foldlevel=1
set expandtab shiftwidth=4 tabstop=4
set linebreak
set nowrap
set pastetoggle=<F2>
set spell               " vim-unimpaired: use [os and ]os
set cpoptions+=J        " Double spacing between sentences
set joinspaces
map * <Plug>(asterisk-*)
nnoremap <leader>a :grep <end>
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

"skim
nmap <silent> <leader>f :Files<CR>
nmap <silent> <leader>gf :GFiles<CR>
nmap <silent> <leader>b :Buffers<CR>

"ale
let g:ale_fix_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = {
    \   'go': ['gometalinter', 'bingo'],
    \   'rust': ['rls', 'cargo'],
    \   'javascript': ['eslint'],
    \}
let g:ale_rust_cargo_check_examples = 1
let g:ale_rust_cargo_use_clippy = 1
let g:ale_rust_cargo_check_tests = 1
let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'rust': ['rustfmt'],
    \   'go': ['gofmt', 'goimports'],
    \   'javascript': ['eslint', 'prettier_eslint', 'importjs'],
    \}

nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> <leader>h :ALEHover<CR>

"neosnippet
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

let g:neosnippet#snippets_directory = $HOME . '/.dotfiles/neovim/snippets'

" vim-test
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tt :TestLast<CR>
nnoremap <silent> <leader>tg :TestVisit<CR>

" terminal
if has('nvim')
    augroup term_settings
        autocmd!
        tnoremap <Esc> <C-\><C-n>
        autocmd TermOpen * setlocal statusline=%{b:term_title}
        let g:neoterm_default_mod=':vertical :belowright'
        let g:neoterm_size='60'
    augroup END
endif


" file type handling
" vimwiki
let g:vimwiki_folding='expr'
let g:vimwiki_list = [{'path': '~/vimwiki',
            \ 'syntax': 'markdown',
            \ 'ext': '.md',
            \ }]

let g:markdown_composer_browser='dot-open'
let g:markdown_composer_autostart=1
let g:markdown_composer_open_browser=0
let g:markdown_composer_syntax_theme='zenburn'

" vim
nnoremap <leader>vc :e $MYVIMRC<cr>
augroup reload_vimrc
    autocmd!
    autocmd reload_vimrc BufWritePost $MYVIMRC nested source $MYVIMRC
    autocmd FileType vim set nofen
    autocmd FileType vim set foldmethod=marker
augroup END

augroup web_settings
    autocmd!
    autocmd FileType html,djangohtml,javascript set shiftwidth=2
    autocmd FileType html,djangohtml,javascript set tabstop=2
augroup END

augroup sh_settings
    autocmd!
    autocmd FileType sh,bash set shiftwidth=2
    autocmd FileType sh,bash set tabstop=2
augroup END

" Git
nnoremap <silent> <leader>gs :Gstatus<cr>

"}}}
