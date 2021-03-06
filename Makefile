.PHONY: help

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`

LOCAL_PROVISION_CONF := deploy/provision.local.yml
WEB_DOCKERFILE := deploy/web.release.Dockerfile

DOCKER := docker
COMPOSE := $(DOCKER)-compose
CIRCLECI := circleci

help:
	@echo "$(APP_NAME):$(APP_VSN)-$(BUILD)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: image
image: ## Build the release Docker image
	@test -n "$(DOCKER_USER)" || { echo "please set DOCKER_USER variable"; exit 1; }
	$(DOCKER) build -f $(WEB_DOCKERFILE) --build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(DOCKER_USER)/$(APP_NAME):$(APP_VSN)-$(BUILD) \
		-t $(APP_NAME):latest \
		-t $(DOCKER_USER)/$(APP_NAME):latest .

.PHONY: ## Push image to docker hub
push-image:
	@test -n "$(DOCKER_USER)" || { echo "please set DOCKER_USER variable"; exit 1; }
	$(DOCKER) push $(DOCKER_USER)/$(APP_NAME):$(APP_VSN)-$(BUILD)
	$(DOCKER) push $(DOCKER_USER)/$(APP_NAME):latest

.PHONY: attach-web-console
attach-web-console: ## Attach running container of web
	$(COMPOSE) -f $(LOCAL_PROVISION_CONF) exec web sh

.PHONY: run
run: ## Run the app and db in Docker - Only for verify the release image, not for development
	$(COMPOSE) -f $(LOCAL_PROVISION_CONF) up -d

.PHONY: stop
stop: ## Stop the app and db in Docker - Only for verify the release image, not for development
	$(COMPOSE) -f $(LOCAL_PROVISION_CONF) down

check-ci-config: ## Verify CircleCI config format
	$(CIRCLECI) config check
