let g:rustfmt_autosave = 0 " ale is used
nnoremap <leader>cr :T cargo run -- <end>
nnoremap <leader>cb :T cargo build<cr>
nnoremap <leader>cp :T cargo bench<cr>
nnoremap <leader>cu :T cargo update<cr>
