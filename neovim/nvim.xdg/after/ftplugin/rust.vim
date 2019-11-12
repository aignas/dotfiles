let g:ale_rust_cargo_check_examples = 1
let g:ale_rust_cargo_use_clippy = 1
let g:ale_rust_cargo_check_tests = 1

let g:rustfmt_autosave = 0 " ale is used
nnoremap <leader>cr :term cargo run -- <end>
nnoremap <leader>cb :term cargo build<cr>
nnoremap <leader>cp :term cargo bench<cr>
nnoremap <leader>cu :term cargo update<cr>

let b:ale_linters = ['rls', 'cargo']
let b:ale_fixers = ['rustfmt']

iabbrev xtestmod #[cfg(test)]<cr>mod tests {<cr>}<cr>
iabbrev xtest #[test]<cr>fn TODO_test() {<cr>assert_eq!(true, false)<cr>}<cr>
