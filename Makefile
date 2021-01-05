# include .env

default: up

PROJECT_NAME ?= drupal8-solr7
COMPOSER_ROOT ?= /app
DRUPAL_ROOT ?= /app/docroot

## help		: Print commands help.
.PHONY: help
help : Makefile
	@sed -n 's/^##//p' $<

## build		: Build from scratch the containers
##		  You can use the build command to target a single container
##		  - make build solr		: This will build the solr container.
.PHONY: build
build:
	@docker-compose build --no-cache $(filter-out $@,$(MAKECMDGOALS))

## up		: Start up the containers
.PHONY: up
up:
    # @todo: What is the impact elsewhere for this?
	docker-compose up -d --remove-orphans

## down		: Shutdown the containers - this command WILL REMOVE CONTAINERS once done.
.PHONY: down
down:
	@echo "Shutting down and removing containers for $(PROJECT_NAME)..."
	@docker-compose down

## stop		: Stop the containers
.PHONY: stop
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

## shell		: Access `cli` container via shell.
.PHONY: shell
shell:
	@docker-compose exec cli bash

## sh		: Access any container via an sh shell.
##		  This will use cli as the base shell if not specifically chosen.
##		  - make sh php			: Shell into the php container.
.PHONY: sh
sh:
	@docker-compose exec $(filter-out $@,$(MAKECMDGOALS)) sh

## prune		: Remove containers and their volumes.
##		  You can optionally pass an argument with the service name to prune single container
##		  - make prune mariadb		: Prune `mariadb` container and remove its volumes.
##		  - make prune mariadb solr	: Prune `mariadb` and `solr` containers and remove their volumes.
.PHONY: prune
prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))


## ps		: List running containers.
.PHONY: ps
ps:
	@docker ps --filter name='$(PROJECT_NAME)'

## composer	:  Executes `composer` command in a specified `COMPOSER_ROOT` directory (default is `/app`).
##		   To use "--flag" arguments include them in quotation marks.
##		   For example: make composer "update drupal/core --with-dependencies"
.PHONY: composer
composer:
	@docker-compose exec cli composer --working-dir=$(COMPOSER_ROOT) $(filter-out $@,$(MAKECMDGOALS))


## logs		: View containers logs.
##		  You can optinally pass an argument with the service name to limit logs
##		  - make logs php		: View `php` container logs.
##		  - make logs nginx php		: View `nginx` and `php` containers logs.
.PHONY: logs
logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
