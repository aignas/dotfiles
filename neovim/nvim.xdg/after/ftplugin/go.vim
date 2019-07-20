let g:go_fmt_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_metalinter_autosave = 0
let g:go_asmfmt_autosave = 0
let g:go_auto_type_info = 1
let g:go_fmt_fail_silently = 1

let b:ale_linters = ['golangci-lint', 'gopls']
let b:ale_fixers = ['gofmt', 'goimports']

nnoremap <silent> <leader>t :e %:h/%:t:r_test.%:e<cr>
nnoremap <silent> <leader>T :e %:s?_test??<cr>

" Snippets
iabbrev xtests tests := []struct{<cr>msg string<cr>wantErr string<cr>}{}<cr><cr>for _, tt := range tests {<cr>t.Run(tt.msg, func(t *testing.T) {<cr>assert.False(t, true)<cr>})<cr>}<cr>
