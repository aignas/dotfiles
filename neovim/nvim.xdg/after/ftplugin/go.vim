let g:go_fmt_command = 'goimports'
let g:go_metalinter_autosave = 1
let g:go_auto_type_info = 1
let g:go_fmt_fail_silently = 1

nnoremap <silent> <leader>t :e %:h/%:t:r_test.%:e<cr>
nnoremap <silent> <leader>T :e %:s?_test??<cr>

" Snippets
iabbrev xtests tests := []struct{<cr>msg string<cr>wantErr string<cr>}{}<cr><cr>for _, tt := range tests {<cr>t.Run(tt.msg, func(t *testing.T) {<cr>assert.False(t, true)<cr>})<cr>}<cr>
