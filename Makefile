.PHONY: lint

lint:
	./script/lint

init:
	git config core.hooksPath .githooks

install:
	./script/bootstrap

reinstall:
	./script/bootstrap --overwrite
