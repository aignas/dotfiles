USER=aignas
PROJECT=shed
LABELS = $(addprefix --label org.label-schema.,\
		 build-date=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
		 vcs-url=https://github.com/$(USER)/$(PROJECT) \
		 vcs-ref=$(shell git rev-parse --short HEAD) \
		 schema-version=1.0)

.PHONY: container
container:
	docker build -t $(USER)/$(PROJECT) $(LABELS) .
	touch $@

.PHONY: push
push:
	docker images
	@if [ ! "$(TRAVIS_BRANCH)" = "master" ]; then \
		echo "branch $(TRAVIS_BRANCH) detected, expected master"; \
	else \
		echo "$(DOCKER_PASS)" | docker login -u $(USER) --password-stdin; \
		docker push $(USER)/$(PROJECT):latest; \
	fi
