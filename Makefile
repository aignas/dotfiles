.PHONY: lint

lint:
	shellcheck **/*.sh

init:
	git config core.hooksPath .githooks
