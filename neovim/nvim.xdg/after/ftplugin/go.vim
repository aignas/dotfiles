let b:ale_linters = ['golangci-lint']
let b:ale_fixers = ['goimports']
setlocal noexpandtab

"autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

nnoremap <silent> <leader>t :e %:h/%:t:r_test.%:e<cr>
nnoremap <silent> <leader>T :e %:s?_test??<cr>

" Snippets
iabbrev xtable tests := []struct{<cr>msg string<cr>wantErr string<cr>}{<cr>{<cr>msg: "ok",<cr>wantErr: "",<cr>},<cr>{<cr>msg: "err",<cr>wantErr: "foo",<cr>},<cr>}<cr><cr>for _, tt := range tests {<cr>t.Run(tt.msg, func(t *testing.T) {<cr>TODO<cr>})<cr>}
iabbrev xtest func TestTODO(t *testing.T) {<cr>TODO<cr>}<cr>
iabbrev example func TestTODO(t *testing.T) {<cr>}<cr>
iabbrev xterr if tt.wantErr != "" {<cr>assert.Error(t, err)<cr>assert.EqualError(t, err, tt.wantErr)<cr>return<cr>}<cr>assert.NoError(t, err)
iabbrev xerr if err != nil {<cr>return err<cr>}
iabbrev xforv for i := range
iabbrev xforp for _, i := range
