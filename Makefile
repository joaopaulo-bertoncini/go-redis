

COMMAND-DOCKER=docker-compose

ISALPINE := $(shell grep 'Alpine' /etc/os-release  -c)
musl=
ifeq ($(ISALPINE), 2)
        musl=-tags musl
endif

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## run: run the application
.PHONY: run
run:
	@go run main.go

current_time = $(shell date "+%Y-%m-%dT%H:%M:%S%z")
git_description = $(shell git describe --always --dirty --tags --long)
linker_flags = '-s -X main.buildTime=${current_time} -X main.version=${git_description}'

## build: build the application
.PHONY: build
build:
	@echo 'Building ...'
	go build ${musl} -ldflags=${linker_flags} -o=./bin/application main.go

## clean: clear generated bin files
.PHONY: clean/apps
clean:
	@echo 'Remove builded files...'
	@rm -rf ./bin

## docker/build: build the local environment for development
.PHONY: docker/build
docker/build:
	@$(COMMAND-DOCKER) build 

## docker/up: start the local stack in background
.PHONY: docker/up
docker/up:
	@$(COMMAND-DOCKER) up -d

## docker/down: shutdown the running containers
.PHONY: docker/down
docker/down:
	@$(COMMAND-DOCKER) down --remove-orphans
