.PHONY: lint

lint:
	@echo "› linting *.sh files"
	@shellcheck **/*.sh

init:
	git config core.hooksPath .githooks
