let g:go_fmt_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_metalinter_autosave = 0
let g:go_asmfmt_autosave = 0
let g:go_auto_type_info = 1
let g:go_fmt_fail_silently = 1

let b:ale_linters = ['golangci-lint', 'gopls']
let b:ale_fixers = ['goimports']

nnoremap <silent> <leader>t :e %:h/%:t:r_test.%:e<cr>
nnoremap <silent> <leader>T :e %:s?_test??<cr>

" Snippets
iabbrev xtable tests := []struct{<cr>msg string<cr>wantErr string<cr>}{<cr>{<cr>msg: "ok",<cr>wantErr: "",<cr>},<cr>{<cr>msg: "err",<cr>wantErr: "foo",<cr>},<cr>}<cr><cr>for _, tt := range tests {<cr>t.Run(tt.msg, func(t *testing.T) {<cr>TODO<cr>})<cr>}<cr>
iabbrev xtest (t *testing.T) {<cr>
iabbrev terr if tt.wantErr != "" {<cr>assert.Error(t, err)<cr>assert.EqualError(t, err, tt.wantErr)<cr>return<cr>}<cr>assert.NoError(t, err)<cr>
iabbrev iferr if err != nil {<cr>
iabbrev xforv for i := range
iabbrev xforp for _, TODO := range
