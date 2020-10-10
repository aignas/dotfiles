let b:ale_linters = ['golangci-lint']
let b:ale_fixers = ['goimports']
setlocal noexpandtab

nnoremap <silent> <leader>t :GoAlternate!<cr>
