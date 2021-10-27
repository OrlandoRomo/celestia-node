#!/usr/bin/make -f
PROJECTNAME=$(shell basename "$(PWD)")
BUILD_DATE=$(shell date)
LAST_COMMIT=$(shell git rev-parse HEAD)
# Replace with the current version
CELESTIA_VERSION="0.1.0"

## help: Get more info on make commands.
help: Makefile
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
.PHONY: help

## build: Build celesita-node binary.
build:
	@echo "--> Building Celestia"
	@go build -ldflags "-X 'main.buildTime=$(BUILD_DATE)' -X 'main.lastCommit=$(LAST_COMMIT)' -X 'main.semanticVersion=$(CELESTIA_VERSION)'" ./cmd/celestia 

## fmt: Formats only *.go (excluding *.pb.go *pb_test.go). Runs `gofmt & goimports` internally.
fmt:
	@find . -name '*.go' -type f -not -path "*.git*" -not -name '*.pb.go' -not -name '*pb_test.go' | xargs gofmt -w -s
	@find . -name '*.go' -type f -not -path "*.git*"  -not -name '*.pb.go' -not -name '*pb_test.go' | xargs goimports -w -local github.com/celestiaorg
	@go mod tidy
.PHONY: fmt

## lint: Linting *.go files using golangci-lint. Look for .golangci.yml for the list of linters.
lint:
	@echo "--> Running linter"
	@golangci-lint run
.PHONY: lint

## test: Running all *_test.go.
test:
	@echo "--> Running tests"
	@go test -v ./...
.PHONY: test
