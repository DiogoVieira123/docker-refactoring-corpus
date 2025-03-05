IMAGE_PREFIX ?= platform

.PHONY: all contexts services api worker auth ca_bundle

all: contexts services

contexts: ca_bundle

services: api worker auth

ca_bundle:
	docker build -t $(IMAGE_PREFIX)/ca_bundle:2024.1 build/ca_bundle

api:
	docker build -t $(IMAGE_PREFIX)/api:dev services/api

worker:
	docker build -t $(IMAGE_PREFIX)/worker:dev services/worker

auth: contexts
	docker build -t $(IMAGE_PREFIX)/auth:dev services/auth
