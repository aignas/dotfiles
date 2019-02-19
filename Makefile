.PHONY: lint

lint: lint-sh lint-vim

lint-sh:
	@echo "linting shell files"
	@rg -l "^#!.*bash" | xargs shellcheck
	@rg -l "^#!.*sh" | xargs shellcheck

lint-vim:
	@echo "linting vim files"
	@fd -e vim | xargs vint

init:
	git config core.hooksPath .githooks

install:
	./script/bootstrap

reinstall:
	./script/bootstrap --overwrite
