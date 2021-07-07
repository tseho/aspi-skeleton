##
## Environment variables
##

ENV ?= dev

ifneq (,$(wildcard ./.env))
	MAKEFILE_DOTENV_PATH=/tmp/$(shell basename $$(pwd)).env.mk
	MAKEFILE_DOTENV=$(shell cat .env | grep -v --perl-regexp '^('$$(env | sed 's/=.*//'g | tr '\n' '|')')\=' | sed 's/=/?=/g' > $(MAKEFILE_DOTENV_PATH); echo '$(MAKEFILE_DOTENV_PATH)')
	include $(MAKEFILE_DOTENV)
endif

# Default values
BUILD_ENV ?= ${ENV}
APP_ENV ?= ${ENV}
DOCKER_PORT_API ?= 8080
DOCKER_PORT_NODE ?= 3000
API_BASEURL ?= http://localhost:${DOCKER_PORT_API}

ifeq ($(ENV), prod)
	COMPOSER_ARGS += --no-dev
	YARN_ARGS += --prod
endif

# Binaries
DOCKER_COMPOSE = docker-compose
COMPOSER = $(DOCKER_COMPOSE) run --rm --no-deps composer $(COMPOSER_ARGS)
YARN = $(DOCKER_COMPOSE) run --rm --no-deps node yarn $(YARN_ARGS)

# Export all variables so they are accessible in the shells created by make
export

##
## Entrypoints
##

.DEFAULT_GOAL := up

.PHONY: up
up: docker-compose-build depencencies docker-compose-up
	@echo "\e[30m\e[42m\n"
	@echo " Application is up and running at http://localhost:$(DOCKER_PORT_NODE)"
	@echo "\e[49m\e[39m\n"

.PHONY: down
down: docker-compose-down

##
## Docker compose
##

.PHONY: docker-compose-up
docker-compose-up:
	$(DOCKER_COMPOSE) up -d --remove-orphan

.PHONY: docker-compose-stop
docker-compose-stop:
	$(DOCKER_COMPOSE) stop

.PHONY: docker-compose-down
docker-compose-down:
	$(DOCKER_COMPOSE) down -v --remove-orphan

.PHONY: docker-compose-build
docker-compose-build:
	$(DOCKER_COMPOSE) build

##
## Dependencies
##

.PHONY: dependencies
depencencies: back/vendor front/node_modules

back/vendor:
	$(COMPOSER) install \
		--no-scripts \
		--no-interaction \
		--no-ansi \
		--prefer-dist \
		--optimize-autoloader

front/node_modules:
	$(YARN) install \
		--frozen-lockfile \
		--no-progress \
		--non-interactive
