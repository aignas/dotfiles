let b:ale_fixers = ['latexindent', 'textlint']

" put into PDF viewer 'nvr --remote-silent %f -c %l' for synctex
let g:vimtex_compiler_progname = 'nvr'
" Disable custom warnings based on regexp
let g:vimtex_quickfix_latexlog = {
      \ 'ignore_filters' : ['Command \\selectfont\s*has changed'],
      \}

" Japanese homework
vnoremap <leader>R "qxi}{<C-R>q}<Esc>Bi\ruby{
inoremap <C-i> \item
inoremap <C-a> \first{}
inoremap <C-b> \second{}
inoremap <C-f> \fillin{
inoremap <C-s> \suffix{
