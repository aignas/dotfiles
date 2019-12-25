let b:ale_linters = ['golangci-lint']
let b:ale_fixers = ['goimports']
setlocal noexpandtab

nnoremap <silent> <leader>t :e %:h/%:t:r_test.%:e<cr>
nnoremap <silent> <leader>T :e %:s?_test??<cr>
