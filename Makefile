USER=aignas
REPO=dotfiles
LABELS = $(addprefix --label org.label-schema.,\
		 build-date=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
		 vcs-url=https://github.com/$(USER)/$(REPO) \
		 vcs-ref=$(shell git rev-parse --short HEAD) \
		 schema-version=1.0)

.PHONY: debian
debian:
	docker build -f shed/Dockerfile.$@ -t $(USER)/$@ $(LABELS) .
	touch $@

.PHONY: shed
shed: debian

.PHONY: push
push: shed
	docker images
	@if [ ! "$(TRAVIS_BRANCH)" = "master" ]; then \
		echo "branch $(TRAVIS_BRANCH) detected, expected master"; \
	else \
		echo "$(DOCKER_PASS)" | docker login -u $(USER) --password-stdin; \
		docker push $(USER)/$^:latest; \
	fi

.PHONY: lint
lint:
	dotr --lint

check: lint shed debshed
