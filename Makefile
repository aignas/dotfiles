.PHONY: lint

lint:
	@echo "linting shell files"
	@shellcheck **/*.sh
	@shellcheck script/*
	@shellcheck bin/*

init:
	git config core.hooksPath .githooks

install:
	./script/bootstrap

reinstall:
	./script/bootstrap --overwrite
